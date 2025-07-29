const express = require('express');

const sellerCategoryController = require('../controllers/sellerCategoryController');

const router = express.Router();

router
    .route('/')
    .get(sellerCategoryController.getAllSellerCategories)
    .post(sellerCategoryController.createSellerCategory);

router
    .route('/:id')
    .get(sellerCategoryController.getSellerCategory)
    .patch(sellerCategoryController.updateSellerCategory)
    .delete(sellerCategoryController.deleteSellerCategory);

module.exports = router;