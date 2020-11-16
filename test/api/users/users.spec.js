const { seedUsers, clearUser, createDepartment } = require('../../helper');

describe('## User APIs', async () => {
  beforeEach(async () => {
    await clearUser();
  });

  describe('# GET /api/users', () => {
    it('should return all users', async () => {
      await seedUsers();

      const res = await chai
        .request(app)
        .get('/api/users');

      expect(res).to.have.status(200);
      expect(res.body.users.length).to.equal(2);
    });
  });

  describe('# POST /api/users', () => {
    it('should create a new user', async () => {
      const department = await createDepartment();
      await seedUsers();
      const user = {
        name: 'Messi',
        email: 'messi@gmail.com',
        department: department._id,
      };
      const res = await chai
        .request(app)
        .post('/api/users')
        .send(user);

      expect(res).to.have.status(201);
      expect(res.body).to.have.property('_id').and.not.equal(undefined);
    });
  });
});
