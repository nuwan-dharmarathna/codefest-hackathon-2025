const jwt = require('jsonwebtoken');
const {User, Buyer, Seller} = require('../models/userModel');
const SellerCategory = require('../models/sellerCategoryModel');

const AppError = require('../utils/appError');
const catchAsync = require('../utils/catchAsync');

const signToken = (id, role) => {
    return jwt.sign(
        { id, role },
        process.env.JWT_SECRET,
        { expiresIn: process.env.JWT_EXPIRES_IN || '30d' }
    );
};

const createSendToken = (user, statusCode, res) => {
  const token = signToken(user._id, user.role);
  
  // Remove password from output
  user.password = undefined;

  // Send token in both response and cookie
  res.cookie('jwt', token, {
    httpOnly: true,
    secure: process.env.NODE_ENV === 'production',
    sameSite: 'strict',
    maxAge: 30 * 24 * 60 * 60 * 1000
  });

  res.status(statusCode).json({
    status: 'success',
    token,
    data: {
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
        location: req.body.location,
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

        newUser = await Seller.create({
            ...commonData,
            category : req.body.category,
            businessName: req.body.businessName,
            businessRegistrationNo: req.body.businessRegistrationNo || ""
        })
    } else {
        return next(new AppError('Invalid user role', 400));
    }

    // 4) sent token response
    createSendToken(newUser, 201, res);
});

exports.signIn = catchAsync(async(req, res, next)=>{
    const {sludiNo, password} = req.body;

    // 1) check the fields are exist
    if (!sludiNo || !password) {
        return next(new AppError('Please provide SLUDI Number and password', 400)); 
    }

    // 2) check the user exist and password is correct
    const user = await User.findOne({sludiNo}).select('+password');

    if (!user || !(await user.comparePassword(password))) {
        return next(new AppError('Incorrect SLUDI or password', 401));
    }

    // 3) Update last login
    user.lastLogin = Date.now();
    await user.save({validateBeforeSave: false});

    // 4) send token to client
    createSendToken(user, 200, res);
});

exports.getMe = catchAsync(async (req, res, next) => {
  let user;
  
  if (req.user.role === 'buyer') {
    user = await Buyer.findById(req.user.id);
  } else if (req.user.role === 'seller') {
    user = await Seller.findById(req.user.id).populate('category');
  }

  if (!user) {
    return next(new AppError('User not found', 404));
  }

  res.status(200).json({
    status: 'success',
    data: {
      user
    }
  });
});

exports.updatePassword = catchAsync(async (req, res, next) => {
  // 1) Get user from collection
  const user = await User.findById(req.user.id).select('+password');

  // 2) Check if POSTed current password is correct
  if (!(await user.comparePassword(req.body.currentPassword))) {
    return next(new AppError('Your current password is wrong', 401));
  }

  // 3) If so, update password
  user.password = req.body.newPassword;
  user.passwordConfirm = req.body.newPasswordConfirm;
  await user.save();

  // 4) Log user in, send JWT
  createSendToken(user, 200, res);
});

exports.updateMyDetails = catchAsync(async (req, res, next) => {
  // 1) Create error if user POSTs password data
  if (req.body.password || req.body.passwordConfirm) {
    return next(
      new AppError(
        'This route is not for password updates. Please use /updatePassword',
        400
      )
    );
  }

  // 2) Filter out unwanted fields that shouldn't be updated
  const filteredBody = {
    firstName: req.body.firstName,
    lastName: req.body.lastName,
    phone: req.body.phone,
    email: req.body.email,
    location: req.body.location,
    image : req.body.image,
  };

  // For sellers, add business-specific fields
  if (req.user.role === 'seller') {
    if (req.body.businessName) filteredBody.businessName = req.body.businessName;
    if (req.body.businessRegistrationNo) filteredBody.businessRegistrationNo = req.body.businessRegistrationNo;
    if (req.body.category) {
      // Validate seller category exists
      const category = await SellerCategory.findById(req.body.category);
      if (!category) {
        return next(new AppError('Invalid seller category', 400));
      }
      filteredBody.category = req.body.category;
    }
  }

  // 3) Update user doc
  let updatedUser;
  if (req.user.role === 'buyer') {
    updatedUser = await Buyer.findByIdAndUpdate(req.user.id, filteredBody, {
      new: true,
      runValidators: true
    });
  } else if (req.user.role === 'seller') {
    updatedUser = await Seller.findByIdAndUpdate(req.user.id, filteredBody, {
      new: true,
      runValidators: true
    }).populate('category');
  }

  res.status(200).json({
    status: 'success',
    data: {
      user: updatedUser
    }
  });
});

exports.protect = catchAsync(async (req, res, next) => {
  let token;

  if (
    req.headers.authorization &&
    req.headers.authorization.startsWith('Bearer ')
  ) {
    token = req.headers.authorization.split(' ')[1];
  } else if (req.cookies.jwt) {
    token = req.cookies.jwt;
  }

  if (!token) {
    return next(
      new AppError('You are not logged in! Please log in to get access.', 401)
    );
  }

  try {
    // 2) Verify token with manual promise wrapper (more reliable than promisify)
    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    // 3) Check if user still exists
    const currentUser = await User.findById(decoded.id);
    if (!currentUser) {
      return next(new AppError('The user belonging to this token no longer exists', 401));
    }

    // 4) Check if user changed password after the token was issued
    if (currentUser.changepasswordAfter(decoded.iat)) {
      return next(new AppError('User recently changed password! Please log in again', 401));
    }

    // 5) Grant access
    req.user = currentUser;
    next();

  } catch (err) {
    console.error('❌ JWT verification failed:', err);

    if (err.name === 'JsonWebTokenError') {
      return next(new AppError('Invalid token. Please log in again!', 401));
    }
    if (err.name === 'TokenExpiredError') {
      return next(new AppError('Your token has expired! Please log in again', 401));
    }

    return next(new AppError(`Authentication failed: ${err.message}`, 401));
  }
});


exports.restrictTo = (...roles) => {
  return (req, res, next) => {
    if (!roles.includes(req.user.role)) {
      return next(
        new AppError('You do not have permission to perform this action', 403)
      );
    }
    next();
  };
};

exports.logout = (req, res) => {
  // Clear the JWT cookie
  res.cookie('jwt', 'loggedout', {
    expires: new Date(Date.now() + 1000), // 1 second expiration
    httpOnly: true
  });

  res.status(200).json({
    status: 'success',
    message: 'Successfully logged out'
  });
};