const { environment } = require('@rails/webpacker');
const { VueLoaderPlugin } = require('vue-loader')
const custom = require('./custom');
const vue = require('./loaders/vue');

environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.append('vue', vue);
environment.config.merge(custom.config);

module.exports = environment;
