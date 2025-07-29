const jwt = require('jsonwebtoken');
const {User, Buyer, Seller} = require('../models/userModel');
const {SellerCategory} = require('../models/sellerCategoryModel');


const AppError = require('../utils/appError');
const catchAsync = require('../utils/catchAsync');

const signToken = (id, role) => {
    return jwt.sign(
        {id, role},
        process.env.JWT_SECRET,
        { expiresIn: process.env.JWT_EXPIRES_IN || '30d' }
    );
};

const createSendToken = (user, statusCode, res) => {
    const token = signToken(user._id, user.role);

    // remove parrword from output
    user.password = undefined;

    res.status(statusCode).json({
        status: 'success',
        token,
        data : {
            user
        }
    });
};


// Register 
exports.signUp = catchAsync(async(req,res, next)=> {
    const {
        role,
        sludiNo,
        nic,
        password,
        passwordConfirm
    } = req.body;

    // 1) check passwords match
    if (password !== passwordConfirm) {
        return next(new AppError('Passwords do no match', 400));
    }

    // 2) check if user already exists
    const existingUser = await User.findOne({ $or : [{sludiNo}, {nic}]});

    if (existingUser) {
        return next(new AppError('User with this email or phone already exists', 400));
    }

    // 3) create new user based on the role
    let newUser;
    const commonData = {
        firstName: req.body.firstName,
        lastName: req.body.lastName,
        phone: req.body.phone,
        email: req.body.email,
        sludiNo: req.body.sludiNo,
        nic: req.body.nic,
        address: req.body.address,
        password: req.body.password,
        role: req.body.role
    };

    if (role === 'buyer') {
        newUser = await Buyer.create(commonData);
    }else if(role === 'seller'){
        // Validate seller category exists
        const category = await SellerCategory.findById(req.body.category);
        if (!category) {
            return next(new AppError('Invalid seller category', 400));
        }

        // Validate subcategory
        if (!category.subCategories.includes(req.body.subCategory)) {
        return next(new AppError('Invalid subcategory for this category', 400));
        }

        newUser = await Seller.create({
            ...commonData,
            category : req.body.category,
            subCategory : req.body.subCategory,
            businessName: req.body.businessName,
            businessRegistrationNo: req.body.businessRegistrationNo
        })
    } else {
        return next(new AppError('Invalid user role', 400));
    }

    // 4) sent token response
    createSendToken(newUser, 201, res);
});

