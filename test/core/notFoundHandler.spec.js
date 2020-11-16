describe('## Not found handler', async () => {
  it('should return not found resource', async () => {
    const res = await chai
      .request(app)
      .get('/not-found-route');

    expect(res.status).to.equal(404);
    expect(res.text).to.equal('Resource not found');
  });
});
