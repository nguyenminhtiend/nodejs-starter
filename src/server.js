if (process.env.NODE_ENV === 'development') {
  require('dotenv').config(); //eslint-disable-line
}

const http = require('http');
const { createTerminus } = require('@godaddy/terminus');
const createApp = require('./app');
const { connect, disconnect } = require('./models');
const { logger } = require('./utils');

const { NODE_ENV, PORT = 3000 } = process.env;

(async () => {
  const app = createApp();
  const server = http.createServer(app);
  createTerminus(server, {
    signals: ['SIGINT', 'SIGTERM'],
    healthChecks: {
      '/healthcheck': () => null,
    },
    onSignal: async () => {
      await disconnect();
      logger.info('Stopping server!');
    },
  });

  server.listen(PORT, async () => {
    await connect();
    logger.info(`Server (${NODE_ENV}) started on ${PORT}`);
  });
})();
