const express = require('express');

const authController = require('../controllers/authController');

const router = express.Router();

router.route('/signUp').post(authController.signUp);
router.route('/signIn').post(authController.signIn);

router.use(authController.protect);
router.route('/me').get(authController.getMe);
router.route('/logout').get(authController.logout);
router.route('/updateMe').patch(authController.updateMyDetails);
router.route('/updatePassword').patch(authController.updatePassword);

module.exports = router;