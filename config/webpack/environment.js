const { environment } = require('@rails/webpacker');
const custom = require('./custom');

environment.config.merge(custom.config);

module.exports = environment;
