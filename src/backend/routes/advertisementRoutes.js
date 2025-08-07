const advertisementController = require('../controllers/advertisementController');
const authController = require('../controllers/authController');

const express = require('express');

const router = express.Router();

router.route('/').get(advertisementController.getAllAdvertisements);
// router.route('/:id').get(advertisementController.getAdvertisement);
router.get('/category/:categoryId', advertisementController.getAdvertisementsByCategory);
router.get('/subcategory/:subCategoryId', advertisementController.getAdvertisementsBySubCategory);

router.use(
    authController.protect,
    authController.restrictTo('seller')
);

router.route('/')
  .post(advertisementController.createAdvertisement);

router.route('/seller').get(advertisementController.getAdvertisementsByUser);

router.route('/:id')
  .patch(advertisementController.updateAdvertisement)
  .delete(advertisementController.deleteAdvertisement);

module.exports = router;