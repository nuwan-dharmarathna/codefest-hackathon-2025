const Advertisement = require('../models/advertisementModel');
const Seller = require('../models/userModel').Seller;
const catchAsync = require('../utils/catchAsync');
const AppError = require('../utils/appError');

const factory = require('./factoryHandler');

exports.createAdvertisement = catchAsync(async(req, res, next)=>{
    // 1) Get seller info
    const seller = await Seller.findById(req.user.id).populate('category');
    if (!seller) {
        return next(new AppError('Only sellers can create product advertisements', 403));
    }

    // 2) Prepare product data
    const advertisementData = {
        seller: req.user.id,
        category: seller.category._id,
        subCategory: req.body.subCategory,
        name: req.body.name,
        description: req.body.description,
        quantity: req.body.quantity,
        unit: req.body.unit,
        deliveryAvailable: req.body.deliveryAvailable,
        location: req.body.location,
        priceTiers: req.body.priceTiers
    };

    // Add delivery radius if delivery is available
    if (productData.deliveryAvailable) {
        productData.deliveryRadius = req.body.deliveryRadius;
    }

    // create advertisement
    const advertisement = await Advertisement.create(advertisementData);

    res.status(201).json({
        status: 'success',
        data: {
        product
        }
    });
});

exports.getAllAdvertisements = factory.getAll(Advertisement);

exports.getAdvertisement = factory.getOne(Advertisement);

exports.updateAdvertisement = catchAsync(async(req, res, next)=>{
    // 1) Check if product exists and belongs to the seller
    const product = await Product.findOne({
        _id: req.params.id,
        seller: req.user.id
    });

    if (!product) {
        return next(new AppError('No product found with that ID or you are not the owner', 404));
    }

    // 2) Filter out fields that shouldn't be updated
    const filteredBody = { ...req.body };
    const restrictedFields = ['seller', 'category'];
    restrictedFields.forEach(field => delete filteredBody[field]);

    // 3) Update product
    Object.assign(product, filteredBody);
    product.updatedAt = Date.now();
    await product.save();

    res.status(200).json({
        status: 'success',
        data: {
        product
        }
    });
});

exports.getAdvertisementsByCategory = catchAsync(async(req,res,next)=>{
    // 1) Check if category exists
    const category = await mongoose.model('SellerCategory').findById(req.params.categoryId);
    if (!category) {
        return next(new AppError('No category found with that ID', 404));
    }

    // 2) Find all subcategories for this category
    const subCategories = await mongoose.model('SubCategory').find({
        category: req.params.categoryId
    }).select('_id');

    // 3) Get all active products in these subcategories
    const advertisements = await Advertisement.find({
        subCategory: { $in: subCategories.map(sc => sc._id) },
        isActive: true
    }).populate('seller', 'firstName lastName businessName').populate('category', 'name').populate('subCategory', 'name');

    res.status(200).json({
        status: 'success',
        results: products.length,
        data: {
        products
        }
    });
});

exports.getAdvertisementsBySubCategory = catchAsync(async(req,res,next)=>{
    // 1) Check if subcategory exists
    const subCategory = await mongoose.model('SubCategory').findById(req.params.subCategoryId);
    if (!subCategory) {
        return next(new AppError('No subcategory found with that ID', 404));
    }

    // 2) Get all active products in this subcategory
    const products = await Product.find({
        subCategory: req.params.subCategoryId,
        isActive: true
    })
        .populate('seller', 'firstName lastName businessName')
        .populate('category', 'name')
        .populate('subCategory', 'name');

    res.status(200).json({
        status: 'success',
        results: products.length,
        data: {
        products
        }
    });
});

exports.deleteAdvertisement = factory.deleteOne(Advertisement);