const path = require('path');
const glob = require('glob');
const express = require('express');

const router = express.Router();

module.exports = (app) => {
  const files = glob.sync('./src/api/**/**-router.js');
  files.forEach((filePath) => {
    const fullPath = path.join(process.cwd(), filePath);
    const relativePath = `./${path.relative(__dirname, fullPath)}`;
    require(relativePath)(router); //eslint-disable-line
  });
  app.use('/api', router);
};
