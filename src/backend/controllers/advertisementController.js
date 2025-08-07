const Advertisement = require('../models/advertisementModel');
const Seller = require('../models/userModel').Seller;
const catchAsync = require('../utils/catchAsync');
const AppError = require('../utils/appError');

const mongoose = require('mongoose');

const factory = require('./factoryHandler');

exports.createAdvertisement = catchAsync(async(req, res, next)=>{
    // 1) Get seller info
    const seller = await Seller.findById(req.user._id).populate('category');
    if (!seller) {
        return next(new AppError('Only sellers can create product advertisements', 403));
    }

    // check the subCategory based on the seller Category
    const subCategory = await mongoose.model('SubCategory').findById(req.body.subCategory);
    if (subCategory.category._id.toString() !== seller.category._id.toString()) {
        return next(new AppError("sellers can't create advertisements with another seller catogries", 403));
    }

    // 2) Prepare product data
    const advertisementData = {
        seller: seller._id,
        category: seller.category,
        subCategory: req.body.subCategory,
        name: req.body.name,
        description: req.body.description,
        quantity: req.body.quantity,
        unit: req.body.unit,
        images: req.body.images,
        deliveryAvailable: req.body.deliveryAvailable,
        location: req.body.location || seller.location,
        priceTiers: req.body.priceTiers
    };

    // Add delivery radius if delivery is available
    if (advertisementData.deliveryAvailable) {
        advertisementData.deliveryRadius = req.body.deliveryRadius;
    }

    // create advertisement
    const advertisement = await Advertisement.create(advertisementData);

    res.status(201).json({
        status: 'success',
        data: {
            advertisement
        }
    });
});

exports.getAllAdvertisements = factory.getAll(Advertisement);

exports.getAdvertisement = factory.getOne(Advertisement);

exports.updateAdvertisement = catchAsync(async(req, res, next)=>{
    // 1) Check if product exists and belongs to the seller
    const advertisement = await Advertisement.findOne({ '_id' :req.params.id, 'seller': req.user._id});

    if (!advertisement) {
        return next(new AppError('No Advertisement found with that ID OR You are not the owner of this Ad.', 404));
    }

    // Is there any purchase requests for this Ad
    const purchaseRequests = await mongoose.model('PurchaseRequest').find({ advertisement : advertisement._id });

    if (!purchaseRequests) {
        return next(new AppError('You Cannot Update this Advertisement due to the purchase Requests', '403'));
    }

    // 2) Filter out fields that shouldn't be updated
    const filteredBody = { ...req.body };
    const restrictedFields = ['seller', 'category', 'subCategory'];
    restrictedFields.forEach(field => delete filteredBody[field]);

    // 3) Update product
    Object.assign(advertisement, filteredBody);
    advertisement.updatedAt = Date.now();
    await advertisement.save();

    res.status(200).json({
        status: 'success',
        data: {
            advertisement
        }
    });
});

exports.getAdvertisementsByCategory = catchAsync(async(req,res,next)=>{
    // 1) Check if category exists
    const category = await mongoose.model('SellerCategory').findById(req.params.categoryId);
    if (!category) {
        return next(new AppError('No category found with that ID', 404));
    }

    const advertisements = await Advertisement.find({category : category._id}).populate('category');

    res.status(200).json({
        status: 'success',
        results: advertisements.length,
        data: {
            advertisements
        }
    });
});

exports.getAdvertisementsBySubCategory = catchAsync(async(req,res,next)=>{
    // 1) Check if subcategory exists
    const subCategory = await mongoose.model('SubCategory').findById(req.params.subCategoryId);
    if (!subCategory) {
        return next(new AppError('No subcategory found with that ID', 404));
    }

    const advertisements = await Advertisement.find({subCategory: subCategory._id}).populate('subCategory');

    res.status(200).json({
        status: 'success',
        results: advertisements.length,
        data: {
            advertisements
        }
    });
});

exports.deleteAdvertisement = factory.deleteOne(Advertisement);