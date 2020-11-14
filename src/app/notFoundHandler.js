module.exports = (app) => {
  app.all('*', (req, res) => {
    res.status(404).send('Resource not found');
  });
};
