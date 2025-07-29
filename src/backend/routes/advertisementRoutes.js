const advertisementController = require('../controllers/advertisementController');
const authController = require('../controllers/authController');

const express = require('express');

const router = express.Router();

router.use(
    authController.protect,
    authController.restrictTo('seller')
);

router
  .route('/')
  .get(advertisementController.getAllAdvertisements)
  .post(advertisementController.createAdvertisement);

router
  .route('/:id')
  .get(advertisementController.getAdvertisement)
  .patch(advertisementController.updateAdvertisement)
  .delete(advertisementController.deleteAdvertisement);

module.exports = router;