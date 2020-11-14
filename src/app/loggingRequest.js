const morgan = require('morgan');
const { logger } = require('../utils');

const { DISABLE_LOGGING } = process.env;

const stream = {
  write: (message) => logger.info(message.trim()),
};

const logRequest = morgan(':remote-addr :method :url HTTP/:http-version', {
  immediate: true,
  stream,

});

const logResponse = morgan(':remote-addr :method :url :status :res[content-length] :response-time ms', {
  stream,
});

module.exports = (app) => {
  if (!DISABLE_LOGGING) {
    app.use(logRequest);
    app.use(logResponse);
  }
};
