const Bid = require('../models/bidModel');
const Tender = require('../models/tenderModel');
const catchAsync = require('../utils/catchAsync');
const AppError = require('../utils/appError');

const factory = require('./factoryHandler');

exports.createTender = catchAsync(async(req,res, next)=>{
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
        deadline: req.body.deadline
    };

    // Add delivery info if required
    if (req.body.deliveryRequired) {
        tenderData.deliveryRequired = true;
        tenderData.deliveryLocation = req.body.deliveryLocation;
    }

    // 2) Create tender
    const tender = await Tender.create(tenderData);

    // Todo:  Notify relevant sellers
    // await notifyRelevantSellers(tender);

    res.status(201).json({
        status: 'success',
        data: {
        tender
        }
    });
});

exports.getAllTenders = factory.getAll(Tender);

exports.getTender = catchAsync(async (req, res, next) => {
  const tender = await Tender.findById(req.params.id)
    .populate('createdBy', 'firstName lastName businessName')
    .populate('category', 'name')
    .populate('subCategory', 'name')
    .populate('acceptedBid')
    .populate({
      path: 'bids',
      populate: {
        path: 'user',
        select: 'firstName lastName businessName'
      }
    });

  if (!tender) {
    return next(new AppError('No tender found with that ID', 404));
  }

  res.status(200).json({
    status: 'success',
    data: {
      tender
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

    // 4) Prepare bid data
    const bid = await Bid.create({
        tender: req.params.id,
        user: req.user.id,
        price: req.body.price,
        quantity: tender.quantity, // Enforce exact quantity
        unit: tender.unit,         // Enforce exact unit
        deliveryAvailable: req.body.deliveryAvailable,
        deliveryRadius: req.body.deliveryRadius,
        notes: req.body.notes
    });

    // 5) Add bid to tender
    tender.bids.push(bidData);
    await tender.save();


    res.status(201).json({
        status: 'success',
        data: {
        bid: tender.bids[tender.bids.length - 1]
        }
    });
});

exports.acceptBid = catchAsync(async (req, res, next) => {
    // 1) Get tender
    const tender = await Tender.findById(req.params.id);
    if (!tender) {
        return next(new AppError('No tender found with that ID', 404));
    }

    // 2) Check if user is the tender creator
    if (!tender.createdBy.equals(req.user.id)) {
        return next(new AppError('Only the tender creator can accept bids', 403));
    }

    // 3) Find the bid
    const bid = tender.bids.id(req.params.bidId);
    if (!bid) {
        return next(new AppError('No bid found with that ID', 404));
    }

    // 4) Mark bid as accepted and close tender
    bid.isAccepted = true;
    tender.acceptedBid = bid._id;
    tender.isClosed = true;
    await tender.save();

    res.status(200).json({
        status: 'success',
        data: {
        tender
        }
    });
});

exports.closeTender = catchAsync(async (req, res, next) => {
  const tender = await Tender.findOneAndUpdate(
    {
      _id: req.params.id,
      createdBy: req.user.id
    },
    { isClosed: true },
    { new: true }
  );

  if (!tender) {
    return next(new AppError('No tender found with that ID or you are not the creator', 404));
  }

  res.status(200).json({
    status: 'success',
    data: {
      tender
    }
  });
});

exports.deleteBid = factory.deleteOne(Bid);