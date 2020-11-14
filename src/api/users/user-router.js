const express = require('express');
const { asyncRoute } = require('../../utils');
const { validator } = require('../../middlewares');
const UserController = require('./user-controller');
const usersSchema = require('./user-schema');

module.exports = (app) => {
  const router = express.Router();

  router.get('/', asyncRoute(UserController.getUsers));
  router.get('/:id', asyncRoute(UserController.getUserById));
  router.post(
    '/',
    validator(usersSchema.createUser),
    asyncRoute(UserController.createUser),
  );

  router.put('/:id', asyncRoute(UserController.updateUser));

  app.use('/users', router);
};
