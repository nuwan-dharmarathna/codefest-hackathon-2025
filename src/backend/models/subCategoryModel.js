const mongoose = require('mongoose');
const slugify = require('slugify');
const {Schema} = mongoose;


const subCategorySchema = new Schema({
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
    },
    createdAt: {
      type: Date,
      default: Date.now
    },
    updatedAt: {
      type: Date,
      default: Date.now
    }
}, { timestamps: true });

subCategorySchema.pre('save', function (next) {
  this.slug = slugify(this.name, { lower: true });
  next();
});

// Index for better query performance
subCategorySchema.index({ category: 1 });
subCategorySchema.index({ name: 'text' });

const SubCategory = mongoose.model('SubCategory', subCategorySchema);

module.exports = SubCategory;