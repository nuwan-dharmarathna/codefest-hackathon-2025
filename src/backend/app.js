const express = require('express');
const mongoSanitize = require('express-mongo-sanitize');
const cookieParser = require('cookie-parser');

const AppError = require('./utils/appError');
const globalErrorHandler = require('./controllers/errorController');
const requestLogger = require('./middleware/loggerMiddleware');

const swaggerUi = require('swagger-ui-express');
const swaggerDocument = require('./docs/swagger.json');

const app = express();

app.use(cookieParser());

// Route files
const userRoutes = require('./routes/userRoutes');
const sellerCategoryRoutes = require('./routes/sellerCategoryRoutes');
const subCategoryRoutes = require('./routes/subCategoryRoutes');
const advertisementRoutes = require('./routes/advertisementRoutes');
const tenderRoutes = require('./routes/tenderRoutes');
const purchaseRequestRoutes = require('./routes/purchaseRequestRoutes');
const notificationRoutes = require('./routes/notificationRoutes');

// Body parser, reading data from body into req.body
app.use(express.json({ limit: '100kb' }));
app.use(express.urlencoded({ extended: true }));

//  Data sanitization
app.use(mongoSanitize());

// Request logging middleware - Put it here
app.use(requestLogger);

// Swagger route
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerDocument));

// Default route
app.get('/', (req, res) => {
  res.send('Welcome to the Govichain Backend API!');
});

// API routes
app.use('/api/v1/auth', userRoutes);
app.use('/api/v1/sellerCategory', sellerCategoryRoutes);
app.use('/api/v1/subCategory', subCategoryRoutes);
app.use('/api/v1/advertisements', advertisementRoutes);
app.use('/api/v1/tenders', tenderRoutes);
app.use('/api/v1/purchases', purchaseRequestRoutes);
app.use('/api/v1/notifications', notificationRoutes);

app.all('*', (req, res, next) => {
  next(new AppError(`Can't find ${req.originalUrl} on this server!`, 404));
});


app.use(globalErrorHandler);

module.exports = app;