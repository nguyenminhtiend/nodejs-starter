const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const helmet = require('helmet');
const loggingRequest = require('./loggingRequest');
const initRoutes = require('./initRoutes');
const errorHandler = require('./errorHandler');
const notFoundHandler = require('./notFoundHandler');

module.exports = () => {
  const app = express();
  app.disable('x-powered-by');
  app.use(helmet());
  app.use(cors());
  app.use(bodyParser.json());
  loggingRequest(app);
  initRoutes(app);
  notFoundHandler(app);
  app.use(errorHandler);

  return app;
};
