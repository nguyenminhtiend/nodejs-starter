const { createLogger, format, transports } = require('winston');

const { combine, timestamp, printf } = format;

const logger = createLogger({
  format: combine(
    timestamp({
      format: 'YYYY-MM-DD HH:mm:ss',
    }),
    printf((log) => `${log.timestamp} ${log.level}: ${log.message}`),
  ),
  transports: [new transports.Console({ level: 'info' })],
});

module.exports = logger;
