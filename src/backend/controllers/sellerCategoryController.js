const SellerCategory = require('../models/sellerCategoryModel');

const factory = require('./factoryHandler');

exports.getAllSellerCategories = factory.getAll(SellerCategory);

exports.getSellerCategory = factory.getOne(SellerCategory);

exports.createSellerCategory = factory.createOne(SellerCategory);

exports.updateSellerCategory = factory.updateOne(SellerCategory);

exports.deleteSellerCategory = factory.deleteOne(SellerCategory);