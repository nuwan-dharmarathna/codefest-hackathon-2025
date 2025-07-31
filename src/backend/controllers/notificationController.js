const catchAsync = require('../utils/catchAsync');
const notificationService = require('../services/notificationService');

exports.getUserNotifications = catchAsync(async(req,res,next)=>{
    const notifications = await notificationService.getUserNotifications(req.user._id);

    res.status(200).json({
        status: 'success',
        results: notifications.length,
        data: {
        notifications
        }
    });
});

exports.markNotificationAsRead = catchAsync(async (req, res, next) => {
  const notification = await notificationService.markAsRead(req.params.notificationId);
  
  res.status(200).json({
    status: 'success',
    data: {
      notification
    }
  });
});