const path = require('path');
const glob = require('glob');

const PurgecssPlugin = require('purgecss-webpack-plugin');

const PATHS = {
  js: path.resolve(__dirname, '..', '..', 'app/javascript'),
  views: path.resolve(__dirname, '..', '..', 'app/views'),
};

module.exports = {
  resolve: {
    alias: {
      vue: 'vue/dist/vue.js',
      '@': PATHS.js,
    },
  },
  plugins: [
    new PurgecssPlugin({
      paths: [
        ...glob.sync(`${PATHS.js}/**/*.{js,vue}`, { nodir: true }),
        ...glob.sync(`${PATHS.views}/**/*`, { nodir: true }),
      ],
    }),
  ],
};
