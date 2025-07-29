const mongoose = require('mongoose');
const slugify = require('slugify');


const subCategorySchema = mongoose.Schema({
    name: {
      type: String,
      required: [true, 'Name is required'],
    },
    slug: {
      type: String,
      unique: true,
    },
    category : {
        type: Schema.Types.ObjectId,
        ref: 'SellerCategory',
        required: [true, 'Category is required']
    }
});

subCategorySchema.pre('save', function (next) {
  this.slug = slugify(this.name, { lower: true });
  next();
});

const SubCategory = mongoose.model('SubCategory', sellerCategorySchema);

module.exports = SubCategory;