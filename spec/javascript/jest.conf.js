const path = require('path')

module.exports = {
  preset: "@vue/cli-plugin-unit-jest",
  rootDir: path.resolve(__dirname, '../../'),
  roots: [
    '<rootDir>/spec/javascript/unit'
  ],
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/app/javascript/$1'
  },
  setupFiles: ['<rootDir>/spec/javascript/setup'],
  coverageDirectory: '<rootDir>/spec/javascript/coverage',
  collectCoverageFrom: [
    'app/javascript/**/*.{js,vue}',
    '!**/node_modules/**'
  ]
};
