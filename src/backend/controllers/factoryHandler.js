const catchAsync = require("../utils/catchAsync")
const AppError = require('../utils/appError');
const ApiFeatures = require('../utils/apiFeatures');

exports.deleteOne = (Model) =>
  catchAsync(async (req, res, next) => {
    const doc = await Model.findByIdAndDelete(req.params.id);

    if (!doc) {
      return next(new AppError('No Document with that id', 404));
    }

    res.status(204).json({
      status: 'success',
      data: null,
    });
  });

exports.updateOne = (Model) =>
  catchAsync(async (req, res, next) => {
    const doc = await Model.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true,
    });

    if (!doc) {
      return next(new AppError('No Document found with that id', 404));
    }

    res.status(200).json({
      status: 'success',
      data: {
        data: doc,
      },
    });
  });

exports.createOne = (Model) =>
  catchAsync(async (req, res, next) => {
    const newDoc = await Model.create(req.body);

    res.status(201).json({
      status: 'success',
      data: {
        data: newDoc,
      },
    });
  });

exports.getOne = (Model, popOptions) =>
  catchAsync(async (req, res, next) => {
    let query = Model.findById(req.params.id);
    if (popOptions) {
      query = query.populate(popOptions);
    }

    const doc = await query;

    if (!doc) {
      return next(new AppError('No Document found with that id', 404));
    }

    res.status(200).json({
      status: 'success',
      data: {
        data: doc,
      },
    });
  });

exports.getAll = (Model) =>
  catchAsync(async (req, res, next) => {
    // To allow for nested GET purchases on item
    let filter = {};
    if (req.params.itemId) filter = { item: req.params.itemId };

    // To allow for nested GET purchases for category
    if (req.params.catId) filter = { category: req.params.catId };

    // To allow for nested GET purchases for category
    // if (req.params.billId) filter = { bill: req.params.billId };

    // if (req.params.salesType) filter = { bill: req.params.salesType };

    const featues = new ApiFeatures(Model.find(filter), req.query)
      .filter()
      .sort({createdAt : 1})
      .limitFields()
      .paginate();

    const doc = await featues.query;



    res.status(200).json({
      status: 'success',
      results: doc.length,
      data: {
        data: doc,
      },
    });
  });