const fs = require('fs');
const path = require('path');
const mongoose = require('mongoose');
const { logger } = require('../utils');

const { MONGO_URI, NODE_ENV } = process.env;

console.log(MONGO_URI);

const connect = async () => {
  mongoose.set('debug', NODE_ENV === 'development');
  await mongoose.connect(MONGO_URI, {
    useCreateIndex: true,
    useNewUrlParser: true,
    useUnifiedTopology: true,
  });
  logger.info('Started mongodb!');
};

const disconnect = async () => {
  await mongoose.disconnect();
  logger.info('Stopped mongodb!');
};

const loadModels = () => {
  const paths = fs.readdirSync(__dirname);
  const models = {};

  paths
    .filter((file) => file !== 'index.js')
    .forEach((file) => {
      const model = require(path.join(__dirname, file)); //eslint-disable-line
      models[model.modelName] = model;
    });
  return models;
};

module.exports = {
  connect,
  disconnect,
  ...loadModels(),
};
