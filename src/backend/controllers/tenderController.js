const Bid = require('../models/bidModel');
const Tender = require('../models/tenderModel');
const catchAsync = require('../utils/catchAsync');
const AppError = require('../utils/appError');
const mongoose = require('mongoose');

const notificationService = require('../services/notificationService');

const factory = require('./factoryHandler');

exports.createTender = catchAsync(async(req,res, next)=>{

    //check the sub category in the sellercategory 
    const subCategory = await mongoose.model('SubCategory').findById(req.body.subCategory);
    if (!subCategory) {
      return next(new AppError('Cannot find a Sub Category provided ID')); 
    }

    if (subCategory.category.toString() !== req.body.category) {
      return next(new AppError('Sub Category and the Seller Category in defferent categories')); 
    }

    // 1) Prepare tender data
    const tenderData = {
        createdBy: req.user.id,
        role: req.user.role,
        title: req.body.title,
        description: req.body.description,
        category: req.body.category,
        subCategory: req.body.subCategory,
        quantity: req.body.quantity,
        unit: req.body.unit,
        deliveryRequired : req.body.deliveryRequired
    };

    // Add delivery info if required
    if (tenderData.deliveryRequired) {
        tenderData.deliveryLocation = req.body.deliveryLocation;
    }

    // 2) Create tender
    const tender = await Tender.create(tenderData);

    // Notify relevant sellers
    const sellers = await mongoose.model('Seller').find({role : 'seller', category : tenderData.category});

    if (!sellers) {
      return next(new AppError('Cannot to find any seller with that category'))
    }

    // Create notifications
    await Promise.all(sellers.map(seller => 
      notificationService.createNotification({
        recipient : seller._id,
        sender : tenderData.createdBy,
        type : 'tender_created',
        relatedEntity : tender._id,
        relatedEntityModel : 'Tender',
        message : `New tender created in your category: ${tender.title}`
      })
    ));

    res.status(201).json({
        status: 'success',
        data: {
        tender
        }
    });
});

exports.getAllTenders = factory.getAll(Tender);

exports.getTender = factory.getOne(Tender);

exports.getAllBidsBasedonTender = catchAsync(async(req, res, next)=>{
  const tender = await Tender.findById(req.params.id);
  if (!tender) {
    return next(new AppError('Cannot to find a  Tender With That ID', 404));
  }

  const bids = await Bid.find({ tender :  tender._id});

  res.status(200).json({
        status: 'success',
        results: bids.length,
        data: {
          bids
        }
    });
});

exports.getMyAllBids = catchAsync(async(req,res, next)=>{
  const user = req.user;

  if (user.role === "buyer") {
    return next(new AppError('You Cannot Add Bids to Tenders', '403'));
  }

  const bids = await Bid.find({user : user._id});

  res.status(200).json({
      status: 'success',
      results: bids.length,
      data: {
        bids
      }
  });
});

exports.submitBid = catchAsync(async (req, res, next) => {
    // 1) Get tender
    const tender = await Tender.findById(req.params.id);
    if (!tender) {
        return next(new AppError('No tender found with that ID', 404));
    }

    // 2) Check if tender is closed
    if (tender.isClosed) {
        return next(new AppError('This tender is closed for bidding', 400));
    }

    // 3) Check if user is eligible to bid
    if (req.user.role !== 'seller') {
        return next(new AppError('Only sellers can submit bids', 403));
    }

    // check the seller already bidded
    const existingBid = await Bid.findOne({ user : req.user._id });
    if (existingBid) {
      return next(new AppError('You Cannot Bid Again to this Tender', 403));
    }

    // check seller category and tender category are same
    if (tender.category.toString() !== req.user.category.toString()) {
      return next(new AppError('You cannot Bed this Tender Because You are not in the Tender category', 403));
    }

    // 4) Prepare bid data
    const bidData = {
        tender: req.params.id,
        user: req.user.id,
        price: req.body.price,
        quantity: tender.quantity, // Enforce exact quantity
        unit: tender.unit,         // Enforce exact unit
        deliveryAvailable: tender.deliveryRequired,
        notes: req.body.notes,
        pickupLocation : req.user.location
    };

    if (bidData.deliveryAvailable) {
      bidData.deliveryRadius = req.body.deliveryRadius
    }

    const bid = await Bid.create(bidData);

    res.status(201).json({
        status: 'success',
        data: {
          bid
        }
    });
});

exports.acceptBid = catchAsync(async (req, res, next) => {
  // get the bid
  const bid = await Bid.findById(req.params.id);
  if (!bid) {
    return next(new AppError('No bid found with that ID', 404));
  }
  // 1) Get tender
  const tender = await Tender.findById(bid.tender);
  if (!tender) {
      return next(new AppError('No tender found with that ID', 404));
  }

  // 2) Check if user is the tender creator
  if (!tender.createdBy.equals(req.user.id)) {
      return next(new AppError('Only the tender creator can accept bids', 403));
  }
  
  // 4) Mark bid as accepted and close tender
  bid.isAccepted = true;
  tender.acceptedBid = bid._id;
  tender.isClosed = true;
  await tender.save();

  // notify to seller
  await notificationService.createNotification({
      recipient: bid.user,
      sender: req.user._id,
      type: 'bid_accepted',
      relatedEntity: bid._id,
      relatedEntityModel: 'Bid',
      message: `Your bid for ${tender.title} has been accepted`
  });

  res.status(200).json({
      status: 'success',
      data: {
      tender
      }
  });
});

exports.deleteBid = factory.deleteOne(Bid);