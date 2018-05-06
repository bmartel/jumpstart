const { environment } = require('@rails/webpacker')
const custom = require('./custom')
const vue =  require('./loaders/vue')

environment.loaders.append('vue', vue)
environment.config.merge(custom)

module.exports = environment
