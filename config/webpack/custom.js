const path = require('path');

module.exports = {
  resolve: {
    alias: {
      vue: 'vue/dist/vue.js',
      '@': path.resolve(__dirname, '..', '..', 'app/javascript'),
    }
  }
}
