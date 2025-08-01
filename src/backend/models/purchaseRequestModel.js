const mongoose = require('mongoose');
const { Schema } = mongoose;

const purchaseRequestSchema = new Schema({
    advertisement: {
        type: Schema.Types.ObjectId,
        ref: 'Advertisement',
        required: true
    },
    buyer: {
        type: Schema.Types.ObjectId,
        ref: 'Buyer',
        required: true
    },
    quantity: {
        type: Number,
        required: true,
        min: [0.1, 'Quantity must be greater than 0']
    },
    unit: {
        type: String,
        required: true,
        enum: ['kg', 'g', 'L', 'ml', 'unit', 'units']
    },
    status: {
        type: String,
        enum: ['pending', 'accepted', 'rejected', 'cancelled', 'paid'],
        default: 'pending'
    },
    rejectionStatus: {
        type: String,
        maxlength: [50, 'Description cannot exceed 50 characters']
    },
    pricePerUnit: {
        type: Number
    },
    totalPrice: {
        type: Number
    },
    wantToImportThem :{
        type: Boolean,
        required: true,
        default: false
    },
    deliveryLocation: String,
    createdAt: {
        type: Date,
        default: Date.now
    }
}, { timestamps: true });

// Auto-calculate price before saving
purchaseRequestSchema.pre('save', async function (next) {
  const Advertisement = mongoose.model('Advertisement');
  const ad = await Advertisement.findById(this.advertisement);
  if (!ad) return next(new Error('Invalid advertisement'));

  const matchedTier = ad.priceTiers.find(tier =>
    this.quantity >= tier.minQuantity && this.quantity <= tier.maxQuantity
  );

  if (!matchedTier) {
    return next(new Error('Requested quantity doesn’t match any price tier'));
  }

  this.pricePerUnit = matchedTier.price;
  this.totalPrice = this.quantity * matchedTier.price;

  next();
});


const PurchaseRequest = mongoose.model('PurchaseRequest', purchaseRequestSchema);
module.exports = PurchaseRequest;