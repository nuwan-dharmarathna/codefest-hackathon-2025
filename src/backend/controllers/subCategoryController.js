const SubCategory = require('../models/subCategoryModel');

const factory = require('./factoryHandler');

exports.getAllSubCategories = factory.getAll(SubCategory);

exports.getSubCategory = factory.getOne(SubCategory);

exports.createSubCategory = factory.createOne(SubCategory);

exports.updateSubCategory = factory.updateOne(SubCategory);

exports.deleteSubCategory = factory.deleteOne(SubCategory);