process.env.NODE_ENV = process.env.NODE_ENV || 'production';

const environment = require('./environment');
const custom = require('./custom');

environment.plugins.insert('Purgecss', custom.plugins.purgecss, { after: 'ExtractText' });

module.exports = environment.toWebpackConfig();
