const { Schema } = require('mongoose');

const locationSchema = new Schema({
    type: {
        type: String,
        enum: ['Point'],
        default: 'Point',
        required: true
    },
    coordinates: {
        type: [Number], // [longitude, latitude]
        required: true,
        validate: {
        validator: function(coords) {
            return coords.length === 2 && 
                coords[0] >= -180 && coords[0] <= 180 && 
                coords[1] >= -90 && coords[1] <= 90;
        },
        message: 'Invalid coordinates format: [longitude, latitude]'
        }
    },
    address: {
        type: String,
        required: [true, 'Address is required']
    },
    placeId: {
        type: String,
        required: [true, 'Google Place ID is required']
    },
    formattedAddress: String,
    city: String,
    state: String,
    country: String,
    postalCode: String
}, { _id: false });

module.exports = locationSchema;