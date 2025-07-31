const Notification = require('../models/notificationModel');

const AppError = require('../utils/appError');

class NotificationService {

    async createNotification({
        recipient,
        sender,
        type,
        relatedEntity,
        relatedEntityModel,
        message
    }){
        try {
            const notification = await Notification.create({
                recipient,
                sender,
                type,
                relatedEntity,
                relatedEntityModel,
                message
            });

            return notification;
        } catch (error) {
            throw new AppError('Failed to create notification', 500);
        }
    }

    async getUserNotifications(userId) {
        try {
        return await Notification.find({ recipient: userId })
            .sort({ createdAt: -1 })
            .populate('sender', 'name')
            .populate('relatedEntity');
        } catch (error) {
        throw new AppError('Failed to fetch notifications', 500);
        }
    }

    async markAsRead(notificationId) {
        try {
        const notification = await Notification.findByIdAndUpdate(
            notificationId,
            { isRead: true },
            { new: true }
        );

        if (!notification) {
            throw new AppError('Notification not found', 404);
        }

        return notification;
        } catch (error) {
        throw new AppError('Failed to mark notification as read', 500);
        }
    }
}

module.exports = new NotificationService();