const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const locationSchema = require('./locationModel');

const {Schema} = mongoose;

const SALT_WORK_FACTOR = 10;
const options = {
    discriminatorKey : 'role',
    timeStamps : true,
    collection: 'users',
    toJSON: { virtuals: true },
    toObject: { virtuals: true }
};

const BaseUserSchema = new Schema({
  firstName: {
    type: String,
    required: [true, 'First name is required'],
    trim: true,
    maxlength: [50, 'First name cannot exceed 50 characters']
  },
  lastName: {
    type: String,
    required: [true, 'Last name is required'],
    trim: true,
    maxlength: [50, 'Last name cannot exceed 50 characters']
  },
  phone: {
    type: String,
    required: [true, 'Phone number is required'],
    unique: true,
    validate: {
      validator: function(v) {
        return /^[0-9]{10}$/.test(v);
      },
      message: props => `${props.value} is not a valid phone number!`
    }
  },
  email: {
    type: String,
    unique: true,
    sparse: true,
    lowercase: true,
    trim: true,
    validate: {
      validator: function(v) {
        return /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(v);
      },
      message: props => `${props.value} is not a valid email address!`
    }
  },
  sludiNo: {
    type: String,
    required: [true, 'SLUDI number is required'],
    unique: true
  },
  nic: {
    type: String,
    required: [true, 'NIC is required'],
    unique: true
  },
  location: {
    type: locationSchema,
    required: [true, 'Location is required']
  },
  password: {
    type: String,
    required: [true, 'Password is required'],
    minlength: [8, 'Password must be at least 8 characters'],
    select: false
  },
  registeredAt: {
    type: Date,
    default: Date.now
  },
  isActivated: {
    type: Boolean,
    default: false
  },
  role: {
    type: String,
    required: [true, 'User role is required'],
    enum: ['buyer', 'seller'],
    default: 'buyer'
  },
  lastLogin: {
    type: Date
  }
}, options);


//password hashing middleware
BaseUserSchema.pre('save', async function(next) {
    if (!this.isModified('password')) return next();

    try {
        const salt = await bcrypt.genSalt(SALT_WORK_FACTOR);
        this.password = await bcrypt.hash(this.password, salt);
    } catch (error) {
        next(error);
    }
});

// Method to compare passwords
BaseUserSchema.methods.comparePassword = async function(candidatePassword) {
  return await bcrypt.compare(candidatePassword, this.password);
};

BaseUserSchema.methods.changepasswordAfter = function (JWTTimestamp) {
  if (this.passwordChangedAt) {
    const changeTimeStamp = parseInt(
      this.passwordChangedAt.getTime() / 1000,
      10,
    );
    return JWTTimestamp < changeTimeStamp;
  }

  // false means password not changed
  return false;
};

// Prevent creating base Users directly
BaseUserSchema.pre('save', function(next) {
  if (!this.role) {
    throw new Error('User must have a role (buyer or seller)');
  }
  next();
});

// main User model
const User = mongoose.model('User', BaseUserSchema);

// Buyer Discriminator 
const Buyer = User.discriminator('buyer', new Schema({}, options));

// Seller Discriminator with Category Reference
const Seller = User.discriminator('seller',
  new Schema({
    category: {
      type: Schema.Types.ObjectId,
      ref: 'SellerCategory',
      required: [true, 'Category is required for sellers']
    },
    businessName: {
      type: String,
      required: [true, 'Business name is required for sellers'],
      maxlength: [100, 'Business name cannot exceed 100 characters']
    },
    businessRegistrationNo: {
      type: String,
      unique: true,
      sparse: true
    }
  }, options)
);

module.exports = {
    User,
    Buyer,
    Seller
}