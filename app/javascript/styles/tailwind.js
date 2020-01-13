const defaultTheme = require('tailwindcss/defaultTheme');

module.exports = {
  theme: {
    extend: {
      colors: {
        primary: defaultTheme.colors.teal['400'],
        secondary: defaultTheme.colors.gray['700'],
        accent: defaultTheme.colors.green['400'],
        success: defaultTheme.colors.green['400'],
        info: defaultTheme.colors.blue['400'],
        warning: defaultTheme.colors.orange['400'],
        error: defaultTheme.colors.red['400'],
      },
    },
  }
};
