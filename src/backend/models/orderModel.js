const mongoose = require('mongoose');
const { Schema } = mongoose;

const orderSchema = new Schema({
  purchaseRequest: {
    type: Schema.Types.ObjectId,
    ref: 'PurchaseRequest',
    required: [true, 'Order must be linked to a purchase request']
  },
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
  seller: {
    type: Schema.Types.ObjectId,
    ref: 'Seller',
    required: true
  },
  quantity: {
    type: Number,
    required: true,
    min: [0.1, 'Quantity must be at least 0.1']
  },
  unit: {
    type: String,
    required: true,
    enum: ['kg', 'g', 'L', 'ml', 'unit', 'units']
  },
  pricePerUnit: {
    type: Number,
    required: true
  },
  totalPrice: {
    type: Number,
    required: true
  },
  status: {
    type: String,
    enum: ['pending', 'paid', 'shipped', 'delivered', 'cancelled'],
    default: 'pending'
  },
  paymentMethod: {
    type: String,
    enum: ['cash', 'card', 'bank-transfer', 'mobile-payment'],
    required: [true, 'Payment method is required']
  },
  paymentStatus: {
    type: String,
    enum: ['pending', 'completed', 'failed', 'refunded'],
    default: 'pending'
  },
  paidAt: Date,
  deliveredAt: Date
}, { timestamps: true });

orderSchema.index({ buyer: 1 });
orderSchema.index({ seller: 1 });
orderSchema.index({ status: 1 });
orderSchema.index({ createdAt: -1 });

module.exports = mongoose.model('Order', orderSchema);
