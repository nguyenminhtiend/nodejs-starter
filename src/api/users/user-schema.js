module.exports = {
  createUser: {
    body: {
      properties: {
        name: { type: 'string', minLength: 1 },
        email: { type: 'string', format: 'email' },
        department: { type: 'string', minLength: 1 },
      },
      required: ['name', 'email', 'department'],
    },
  },
};
