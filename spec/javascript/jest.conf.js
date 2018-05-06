const path = require('path')

module.exports = {
  rootDir: path.resolve(__dirname, '../../'),
  roots: [
    '<rootDir>/spec/javascript/unit'
  ],
  moduleFileExtensions: [
    'js',
    'json',
    'vue'
  ],
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/app/javascript/$1'
  },
  transform: {
    '^.+\\.js$': '<rootDir>/node_modules/babel-jest',
    '.*\\.(vue)$': '<rootDir>/node_modules/vue-jest'
  },
  snapshotSerializers: ['<rootDir>/node_modules/jest-serializer-vue'],
  setupFiles: ['<rootDir>/spec/javascript/setup'],
  coverageDirectory: '<rootDir>/spec/javascript/coverage',
  collectCoverageFrom: [
    'app/javascript/**/*.{js,vue}',
    '!**/node_modules/**'
  ]
}
