module.exports = {
  plugins: [
    require('tailwindcss')('./app/javascript/styles/tailwind.js'),
    require('autoprefixer'),
    require('postcss-import'),
  ],
};
