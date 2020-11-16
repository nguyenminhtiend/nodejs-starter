const path = require('path');
const chai = require('chai');
const sinon = require('sinon');
const chaiHttp = require('chai-http');
const chaiLike = require('chai-like');

require('dotenv').config({
  path: path.resolve(process.cwd(), '.env.test'),
});

const { connect } = require('../src/models');
const createApp = require('../src/app');

(async () => {
  chai.use(chaiHttp);
  chai.use(chaiLike);

  global.chai = chai;
  global.expect = chai.expect;
  global.sinon = sinon;

  await connect();

  const app = createApp();
  global.app = app;
})();
