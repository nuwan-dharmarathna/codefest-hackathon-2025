const purchaseRequestController = require('../controllers/purchaseRequestController');
const authController = require('../controllers/authController');

const express = require('express');

const router = express.Router();

router.use(authController.protect);

router.route('/').post(purchaseRequestController.createPurchaseRequest);
router.route('/advertisement/:id').get(purchaseRequestController.getRequestsForAdvertisement); // wrong path
router.route('/user').get(purchaseRequestController.getRequestsBasedOnUser);
router
.route('/:id')
.get(purchaseRequestController.getPurchaseRequest)
.delete(purchaseRequestController.deletePurchaseRequest);

router.use(authController.restrictTo('seller'));
router.route('/reply/:id').patch(purchaseRequestController.replyToPurchaseRequest);

module.exports = router; 