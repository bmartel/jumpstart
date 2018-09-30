const path = require('path');
const glob = require('glob');

const PurgecssPlugin = require('purgecss-webpack-plugin');

const PATHS = {
  js: path.resolve(__dirname, '..', '..', 'app/javascript'),
  views: path.resolve(__dirname, '..', '..', 'app/views'),
  helpers: path.resolve(__dirname, '..', '..', 'app/helpers'),
  controllers: path.resolve(__dirname, '..', '..', 'app/controllers'),
};

const paths = [
  ...glob.sync(`${PATHS.js}/**/*.{js,vue}`, { nodir: true }),
  ...glob.sync(`${PATHS.views}/**/*.erb`, { nodir: true }),
  ...glob.sync(`${PATHS.helpers}/**/*.rb`, { nodir: true }),
  ...glob.sync(`${PATHS.controllers}/**/*.rb`, { nodir: true }),
];

class TailwindExtractor {
  static extract(content) {
    return content.match(/[A-z0-9-:\/]+/g) || [];
  }
}

module.exports = {
  watchOptions: {
    poll: true,
  },
  devServer: {
    host: '0.0.0.0',
  },
  config: {
    resolve: {
      alias: {
        vue: 'vue/dist/vue.js',
        '@': PATHS.js,
      },
    },
  },
  plugins: {
    purgecss: new PurgecssPlugin({
      whitelist: ['*', 'button', 'img', 'input', 'optgroup', 'select', 'textarea', /\[.*\]/, /::.+/],
      paths,
      extractors: [
        {
          extractor: TailwindExtractor,
          extensions: ['html', 'erb', 'haml', 'js', 'vue', 'rb'],
        },
      ],
    }),
  },
};
