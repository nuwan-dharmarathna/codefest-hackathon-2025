const PurchaseRequest = require('../models/purchaseRequestModel');
const Advertisement = require('../models/advertisementModel');
const Order = require('../models/orderModel');

const catchAsync = require('../utils/catchAsync');
const AppError = require('../utils/appError');

const factory = require('./factoryHandler');

exports.createPurchaseRequest = catchAsync(async(req, res, next)=>{
    const { advertisementId, quantity, wantToImport} = req.body;

    const buyer = req.user;

    // Find the advertisement
    const advertisement = await Advertisement.findById(advertisementId);
    if (!advertisement) {
        return next(new AppError('Advertisement not found', 404));
    }

    // Match price tier
    const matchedTier = advertisement.priceTiers.find(tier =>
      quantity >= tier.minQuantity && quantity <= tier.maxQuantity
    );

    if (!matchedTier) {
        return next(new AppError('Quantity does not match any price tier', 404));
    }

    // check delivery is available
    const deliveryStatus = advertisement.deliveryAvailable;

    if (deliveryStatus == false && wantToImport == true) {
        return next(new AppError('Seller does not provide any delivery option', 404));
    }

    let deliveryLocation = null;

    if (deliveryStatus == true && wantToImport == true) {
        deliveryLocation = req.body.deliveryLocation || buyer.location
    }


    // create the request
    const request = {
        advertisement : advertisement._id,
        buyer : buyer._id,
        quantity : req.body.quantity,
        unit : advertisement.unit,
        pricePerUnit : matchedTier.price,
        totalPrice : matchedTier.price * quantity,
        wantToImportThem : wantToImport,
        deliveryLocation : deliveryLocation
    };

    const purchaseRequest = await PurchaseRequest.create(request);

    res.status(201).json({
        status: 'success',
        data: {
            purchaseRequest
        }
    });

});

exports.getRequestsForAdvertisement = catchAsync(async(req, res, next)=>{
    const {advertisementId} = req.params;
    const seller = req.seller;

    // Find the advertisement
    const advertisement = await Advertisement.findById(advertisementId);
    if (!advertisement) {
        return next(new AppError('Advertisement not found', 404));
    }

    if (advertisement.seller.toString() !== seller._id.toString()) {
        return next(new AppError('Not authorized to view this ad\'s requests', 403));
    }

    // Fetch purchase requests for this ad
    const requests = await PurchaseRequest.find({ advertisement: advertisementId })
      .populate('buyer')
      .sort({ createdAt: -1 });

    res.status(201).json({
        status: 'success',
        results: requests.length,
        data: {
            requests
        }
    });
});

exports.getRequestsBasedOnUser = catchAsync(async(req, res, next)=>{
    const user = req.user;

    // Fetch purchase requests
    const requests = await PurchaseRequest.find({buyer: user._id}).sort({createdAt : -1});

    res.status(201).json({
        status: 'success',
        results: requests.length,
        data: {
            requests
        }
    });
});

exports.replyToPurchaseRequest = catchAsync(async(req,res,next)=>{
    const { purchaseRequestStatus, description, paymentMethod } = req.body;

    // Find the purchase Request
    const purchaseRequest = await PurchaseRequest.findById(req.params.id);
    if (!purchaseRequest) {
        return next(new AppError('No Purchase Request found with that ID', 404));
    }

    // 2) Check if user is the advertisement creator
    const advertisement = await Advertisement.findById(purchaseRequest.advertisement);
    if (advertisement.seller.toString() !== req.user._id.toString()) {
        return next(new AppError('Only the Advertisement creator can reply to this request', 403));
    }

    // handle accept criteria

    if(purchaseRequestStatus === 'accepted' && paymentMethod === null){
        return next(new AppError('Must have a payment method for the accept purchaces', '403'));
    }

    if (purchaseRequestStatus === 'rejected' && description === null) {
        return next(new AppError('The reason for rejection must be clearly stated.', '403'));
    }

    if(purchaseRequestStatus === 'accepted'){
        // update the purchase request
        purchaseRequest.status = 'accepted';

        // reduce the main quantity of ad
        advertisement.quantity = advertisement.quantity - purchaseRequest.quantity;

        // make the order
        const newOrder = {
            purchaseRequest : purchaseRequest._id,
            advertisement : advertisement._id,
            buyer : purchaseRequest.buyer,
            seller : req.user._id,
            quantity : purchaseRequest.quantity,
            unit : advertisement.unit,
            pricePerUnit : purchaseRequest.pricePerUnit,
            totalPrice : purchaseRequest.totalPrice,
            paymentMethod : paymentMethod,
        };

        const order = await Order.create(newOrder);

        await purchaseRequest.save();

        await advertisement.save();

        res.status(201).json({
            status: 'success',
            data: {
                order
            }
        });
    } else if (purchaseRequestStatus === 'rejected') {
        purchaseRequest.status = 'rejected';
        purchaseRequest.rejectionStatus = description;
        await purchaseRequest.save();

        res.status(200).json({
            status: 'success',
            message: 'Purchase request rejected successfully'
        });
    }
})

exports.getPurchaseRequest = factory.getOne(PurchaseRequest);

exports.deletePurchaseRequest = factory.deleteOne(PurchaseRequest);
