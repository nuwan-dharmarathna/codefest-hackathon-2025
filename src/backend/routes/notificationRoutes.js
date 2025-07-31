const notificationController = require('../controllers/notificationController');
const authController = require('../controllers/authController');

const express = require('express');

const router = express.Router();

router.use(authController.protect);

router.get('/my', notificationController.getUserNotifications);
router.patch('/:notificationId/read', notificationController.markNotificationAsRead);

module.exports = router;
