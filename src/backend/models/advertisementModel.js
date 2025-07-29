const mongoose = require('mongoose');
const {Schema} = mongoose;

const priceTierSchema = new Schema({
    minQuantity: { type: Number, required: true },
    maxQuantity: { type: Number, required: true },
    price: { type: Number, required: true },
    unit: { type: String, required: true, enum: ['kg', 'g', 'L', 'ml', 'unit', 'units'] }
}, { _id: false });

const advertisementSchema = new Schema({
  seller: {
    type: Schema.Types.ObjectId,
    ref: 'Seller',
    required: true
  },
  category: {
    type: Schema.Types.ObjectId,
    ref: 'SellerCategory',
    required: true
  },
  subCategory: {
    type: Schema.Types.ObjectId,
    ref: 'SubCategory',
    required: true,
    validate: {
      validator: async function(subCategoryId) {
        // Validate that subcategory belongs to seller's category
        const subCategory = await mongoose.model('SubCategory').findById(subCategoryId);
        if (!subCategory) return false;
        
        const seller = await mongoose.model('Seller').findById(this.seller);
        return seller.category.equals(subCategory.category);
      },
      message: 'Subcategory must belong to seller\'s registered category'
    }
  },
  name: {
    type: String,
    required: [true, 'Advertisement name is required'],
    trim: true,
    maxlength: [100, 'Advertisement name cannot exceed 100 characters']
  },
  description: {
    type: String,
    required: [true, 'Description is required'],
    maxlength: [500, 'Description cannot exceed 500 characters']
  },
  quantity: {
    type: Number,
    required: [true, 'Quantity is required'],
    min: [0, 'Quantity cannot be negative']
  },
  unit: {
    type: String,
    required: true,
    enum: ['kg', 'g', 'L', 'ml', 'unit', 'units']
  },
  deliveryAvailable: {
    type: Boolean,
    required: true,
    default: false
  },
  deliveryRadius: {
    type: Number,
    required: function() { return this.deliveryAvailable; },
    min: [0, 'Delivery radius cannot be negative']
  },
  location: {
    type: String,
    required: [true, 'Location is required']
  },
  priceTiers: {
    type: [priceTierSchema],
    required: true,
    validate: {
      validator: function(tiers) {
        // Ensure no overlapping quantity ranges
        for (let i = 0; i < tiers.length; i++) {
          for (let j = i + 1; j < tiers.length; j++) {
            if (Math.max(tiers[i].minQuantity, tiers[j].minQuantity) <= 
                Math.min(tiers[i].maxQuantity, tiers[j].maxQuantity)) {
              return false;
            }
          }
        }
        return tiers.length > 0;
      },
      message: 'Price tiers have overlapping quantities or no tiers provided'
    }
  },
  images: [{
    type: String,
    validate: {
      validator: function(v) {
        return /\.(jpe?g|png|gif|bmp)$/i.test(v);
      },
      message: props => `${props.value} is not a valid image file!`
    }
  }],
  createdAt: {
    type: Date,
    default: Date.now
  },
  updatedAt: {
    type: Date,
    default: Date.now
  },
  isActive: {
    type: Boolean,
    default: true
  }
}, { timestamps: true });

// Middleware to validate seller's category matches the product category
advertisementSchema.pre('save', async function(next) {
  const Seller = mongoose.model('Seller');
  const seller = await Seller.findById(this.seller).populate('category');
  
  if (!seller) {
    throw new Error('Invalid seller reference');
  }
  
  if (!seller.category._id.equals(this.category)) {
    throw new Error('Product category must match seller\'s registered category');
  }
  
  next();
});

// Indexes for better query performance
advertisementSchema.index({ seller: 1 });
advertisementSchema.index({ category: 1 });
advertisementSchema.index({ subCategory: 1 });
advertisementSchema.index({ isActive: 1 });
advertisementSchema.index({ location: 'text', name: 'text', description: 'text' });

const Advertisement = mongoose.model('Advertisement', advertisementSchema);

module.exports = Advertisement;
