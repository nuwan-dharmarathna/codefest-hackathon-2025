const tenderController = require('../controllers/tenderController');
const authController = require('../controllers/authController');

const express = require('express');

const router = express.Router();

router.use(authController.protect);
router.route('/').post(tenderController.createTender).get(tenderController.getAllTenders);
router.route('/my-bids').get(tenderController.getMyAllBids);
// router.route('/:id').get(tenderController.getTender);
router.route('/accept-bid/:id').patch(tenderController.acceptBid);
router.route('/:id/bids').get(tenderController.getAllBidsBasedonTender);

router.use(authController.restrictTo('seller'));
router.route('/bids/:id').post(tenderController.submitBid);
router.route('/seller').get(tenderController.getTendersBasedOnSellerCategory);
router.route('/:id').delete(tenderController.deleteBid);

module.exports = router; 