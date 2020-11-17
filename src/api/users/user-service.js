const { User } = require('../../models');

const getUsers = async () => {
  const users = await User.find().populate('department');

  return { usersss: users };
};

const getUserById = async (id) => {
  const user = await User.findById(id);
  return { user };
};

const createUser = async (user) => {
  const userCreated = await User.create(user);
  return userCreated;
};

const updateUser = async (id, user) => {
  const updatedUser = await User.updateOne({ _id: id }, { $set: user });
  return updatedUser;
};

module.exports = {
  getUsers,
  getUserById,
  createUser,
  updateUser,
};
