const express = require('express');
const sanitize = require('perfect-express-sanitizer');
const cookieParser = require('cookie-parser');

const AppError = require('./utils/appError');
const globalErrorHandler = require('./controllers/errorController');
const requestLogger = require('./middleware/loggerMiddleware');

const app = express();

app.use(cookieParser());

// Route files
const userRoutes = require('./routes/userRoutes');
const sellerCategoryRoutes = require('./routes/sellerCategoryRoutes');

// Body parser, reading data from body into req.body
app.use(express.json({ limit: '100kb' }));
app.use(express.urlencoded({ extended: true }));

//  Data sanitization
app.use(
  sanitize.clean({
    xss: true,
    noSql: true,
    sql: true,
  }),
);

// Request logging middleware - Put it here
app.use(requestLogger);

// Default route
app.get('/', (req, res) => {
  res.send('Welcome to the Govichain Backend API!');
});

// API routes
app.use('/api/v1/auth', userRoutes);
app.use('/api/v1/sellerCategory', sellerCategoryRoutes);


app.all('*', (req, res, next) => {
  next(new AppError(`Can't find ${req.originalUrl} on this server!`, 404));
});


app.use(globalErrorHandler);

module.exports = app;