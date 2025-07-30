const tenderController = require('../controllers/tenderController');
const authController = require('../controllers/authController');

const express = require('express');

const router = express.Router();

router.use(authController.protect);
router.route('/').post(tenderController.createTender).get(tenderController.getAllTenders);
router.route('/:id').get(tenderController.getTender);
router.route(':id/accept-bid/:bidId').patch(tenderController.acceptBid);
router.route(':id/close').patch(tenderController.closeTender);

router.use(authController.restrictTo('seller'));
router.route(':id/bids').post(tenderController.submitBid);
router.route('/:id').delete(tenderController.deleteBid);

module.exports = router; 