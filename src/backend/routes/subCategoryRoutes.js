const express = require('express');

const subCategoryController = require('../controllers/subCategoryController');

const router = express.Router();

router
    .route('/')
    .get(subCategoryController.getAllSubCategories)
    .post(subCategoryController.createSubCategory);

router
    .route('/:id')
    .get(subCategoryController.getSubCategory)
    .patch(subCategoryController.updateSubCategory)
    .delete(subCategoryController.deleteSubCategory);

router.route('/category/:id').get(subCategoryController.getAllSubCategoriesAccordingToSellerCategory);

module.exports = router;