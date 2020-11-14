const { AppError, logger } = require('../utils');

const { DISABLE_LOGGING } = process.env;

module.exports = (err, req, res, next) => {
  if (!DISABLE_LOGGING) {
    logger.error(JSON.stringify(err));
  }
  if (err instanceof AppError) {
    res.status(err.code).json({ message: err.message, errors: err.errors });
  } else {
    res.status(500).json({ message: err.message });
  }
  next();
};
