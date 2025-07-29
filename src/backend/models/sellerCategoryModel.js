const mongoose = require('mongoose');
const slugify = require('slugify');

const sellerCategorySchema = new mongoose.Schema({
  name: {
    type: String,
    unique: true,
  },
  slug: {
    type: String,
    unique: true,
  },
  description: {
    type: String,
    maxlength: [30, 'Description cannot exceed 30 characters']
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

sellerCategorySchema.pre('save', function (next) {
  this.slug = slugify(this.name, { lower: true });
  next();
});

const SellerCategory = mongoose.model('SellerCategory', sellerCategorySchema);

module.exports = SellerCategory;