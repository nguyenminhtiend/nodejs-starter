const { User, Department } = require('../../src/models');

const seedUsers = async () => {
  const { _id: department } = await Department.create({ name: 'Test' });
  await User.insertMany([
    { name: 'Messi', email: 'messi@gmai.com', department },
    { name: 'Messi1', email: 'messi1@gmai.com', department },
  ]);
};

const createDepartment = async () => {
  const department = await Department.create({ name: 'New department' });
  return department;
};

const clearUser = async () => {
  await User.deleteMany({});
  await Department.deleteMany({});
};

module.exports = {
  seedUsers,
  clearUser,
  createDepartment,
};
