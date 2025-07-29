const express = require('express');
const sanitize = require('perfect-express-sanitizer');

const AppError = require('./utils/appError');
const globalErrorHandler = require('./controllers/errorController');

const app = express();

// Route files
const userRoutes = require('./routes/userRoutes');

// Body parser, reading data from body into req.body
app.use(express.json({ limit: '100kb' }));

app.use(express.urlencoded({ extended: true }));

// Data sanitization against SQL query injection
app.use(
  sanitize.clean({
    xss: true,
    noSql: true,
    sql: true,
  }),
);

// routes
app.get('/', (req, res) => {
  res.send('Welcome to the Govichain Backend API!');
});

app.use('/api/v1/auth', userRoutes);

app.all('*', (req, res, next) => {
  next(new AppError(`Can't find ${req.originalUrl} on this server!`, 404));
});

// global error handling
app.use(globalErrorHandler);

module.exports = app;