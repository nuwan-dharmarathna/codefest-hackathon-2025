const mongoose = require('mongoose');
const { Schema } = mongoose;

const bidSchema = new Schema({
  tender: {
    type: Schema.Types.ObjectId,
    ref: 'Tender',
    required: [true, 'Bid must belong to a tender']
  },
  user: {
    type: Schema.Types.ObjectId,
    ref: 'Seller',
    required: [true, 'Bid must have a user'],
  },
  price: {
    type: Number,
    required: [true, 'Bid must have a price']
  },
  quantity: {
    type: Number,
    required: [true, 'Bid must specify quantity']
  },
  unit: {
    type: String,
    required: [true, 'Bid must specify unit'],
    enum: ['kg', 'g', 'L', 'ml', 'unit', 'dozen']
  },
  pickupLocation: { // Where the goods can be picked up
    type: String,
    required: [true, 'Pickup location is required']
  },
  deliveryAvailable: {
    type: Boolean,
    default: false
  },
  deliveryRadius: Number,
  notes: String,
  isAccepted: {
    type: Boolean,
    default: false
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
}, { timestamps: true });

// Indexes
bidSchema.index({ tender: 1 });
bidSchema.index({ user: 1 });
bidSchema.index({ isAccepted: 1 });

// Middleware to validate quantity matches tender quantity
bidSchema.pre('save', async function(next) {
  const tender = await mongoose.model('Tender').findById(this.tender);
  if (!tender) {
    throw new Error('Tender not found');
  }
  
  if (this.quantity !== tender.quantity) {
    throw new Error(`Bid quantity must exactly match tender quantity (${tender.quantity} ${tender.unit})`);
  }
  
  if (this.unit !== tender.unit) {
    throw new Error(`Bid unit must match tender unit (${tender.unit})`);
  }
  
  next();
});

const Bid = mongoose.model('Bid', bidSchema);

module.exports = Bid;