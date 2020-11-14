const {
  getUsers,
  createUser,
  getUserById,
  updateUser,
} = require('./user-service');

module.exports = {
  async getUsers(req, res) {
    const result = await getUsers();
    res.json(result);
  },

  async getUserById(req, res) {
    const { id } = req.params;
    const result = await getUserById(id);
    res.json(result);
  },

  async createUser(req, res) {
    const result = await createUser(req.body);
    res.status(201).json(result);
  },

  async updateUser(req, res) {
    const { id } = req.params;
    const result = await updateUser(id, req.body);
    res.json(result);
  },
};
