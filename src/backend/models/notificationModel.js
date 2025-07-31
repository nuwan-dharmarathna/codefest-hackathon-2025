const mongoose = require('mongoose');

const notificationSchema = new mongoose.Schema({
  recipient: { 
    type: mongoose.Schema.Types.ObjectId, 
    ref: 'User', 
    required: true 
  },
  sender: { 
    type: mongoose.Schema.Types.ObjectId, 
    ref: 'User' 
  },
  type: { 
    type: String, 
    required: true,
    enum: ['tender_created', 'bid_accepted', 'purchase_request', 'purchase_accepted']
  },
  relatedEntity: { 
    type: mongoose.Schema.Types.ObjectId,
    required: true,
    refPath: 'relatedEntityModel'
  },
  relatedEntityModel: {
    type: String,
    required: true,
    enum: ['Tender', 'Bid', 'PurchaseRequest']
  },
  message: { type: String, required: true },
  isRead: { type: Boolean, default: false },
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Notification', notificationSchema);