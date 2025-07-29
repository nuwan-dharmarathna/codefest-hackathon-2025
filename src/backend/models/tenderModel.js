const mongoose = require('mongoose');
const {Schema} = mongoose;

const locationSchema = require('./locationModel');

const tenderSchema = new Schema({
  createdBy: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: [true, 'Tender must have a creator']
  },
  role: {
    type: String,
    enum: ['buyer', 'seller'],
    required: true
  },
  title: {
    type: String,
    required: [true, 'Tender must have a title'],
    maxlength: [100, 'Title cannot exceed 100 characters']
  },
  description: {
    type: String,
    required: [true, 'Tender must have a description'],
    maxlength: [1000, 'Description cannot exceed 1000 characters']
  },
  category: {
    type: Schema.Types.ObjectId,
    ref: 'SellerCategory',
    required: [true, 'Tender must target a category']
  },
  subCategory: {
    type: Schema.Types.ObjectId,
    ref: 'SubCategory'
  },
  quantity: {
    type: Number,
    required: [true, 'Tender must specify quantity']
  },
  unit: {
    type: String,
    required: [true, 'Tender must specify unit'],
    enum: ['kg', 'g', 'L', 'ml', 'unit', 'units']
  },
  deliveryRequired: {
    type: Boolean,
    default: false
  },
  deliveryLocation: locationSchema,
  deadline: {
    type: Date,
    required: [true, 'Tender must have a deadline']
  },
  isClosed: {
    type: Boolean,
    default: false
  },
  acceptedBid: {
    type: Schema.Types.ObjectId,
    ref: 'Bid'
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
}, { timestamps: true });

// Virtual for bids (not stored in DB, just for querying)
tenderSchema.virtual('bids', {
  ref: 'Bid',
  localField: '_id',
  foreignField: 'tender'
});

// Indexes for better performance
tenderSchema.index({ createdBy: 1 });
tenderSchema.index({ category: 1 });
tenderSchema.index({ subCategory: 1 });
tenderSchema.index({ isClosed: 1 });
tenderSchema.index({ deadline: 1 });
tenderSchema.index({ createdAt: -1 });

const Tender = mongoose.model('Tender', tenderSchema);

module.exports = Tender;