const SubCategory = require('../models/subCategoryModel');
const SellerCategory = require('../models/sellerCategoryModel');

const catchasync = require('../utils/catchAsync');
const AppError = require('../utils/appError');

const factory = require('./factoryHandler');

exports.getAllSubCategories = factory.getAll(SubCategory);

exports.getAllSubCategoriesAccordingToSellerCategory = catchasync(async(req, res, next)=>{
    // get the category id
    const categoryId = req.params.id;

    const sellerCategory = await SellerCategory.findById(categoryId);
    if (!sellerCategory) {
        return next(new AppError('Cannot find a seller Category with that ID', '404'));
    }

    // get all subcategories related to the seller category
    const subCategories = await SubCategory.find({ 'category': sellerCategory._id });

    res.status(201).json({
        status: 'success',
        results: subCategories.length,
        data: {
            subCategories
        }
    });
});

exports.getSubCategory = factory.getOne(SubCategory);

exports.createSubCategory = factory.createOne(SubCategory);

exports.updateSubCategory = factory.updateOne(SubCategory);

exports.deleteSubCategory = factory.deleteOne(SubCategory);