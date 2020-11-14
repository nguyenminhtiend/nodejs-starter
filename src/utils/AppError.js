class AppError extends Error {
  constructor(message, statusCode, errors) {
    super(message);
    this.name = 'AppError';
    this.message = message || 'Internal Server Error!';
    this.code = statusCode || 500;
    this.errors = errors;
  }
}

module.exports = AppError;
