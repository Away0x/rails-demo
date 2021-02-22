const tailwindcss = require('tailwindcss');

const environment = {
  plugins: [
    require('postcss-import'),
    tailwindcss('./app/frontend/stylesheets/tailwind.config.js'),
    require('postcss-flexbugs-fixes'),
    require('postcss-preset-env')({
      autoprefixer: {
        flexbox: 'no-2009',
      },
      stage: 3
    }),
  ]
}

module.exports = environment
