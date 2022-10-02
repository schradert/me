// jest.config.js
// Sync object
/** @type {import('@jest/types').Config.InitialOptions} */
module.exports = {
  moduleFileExtensions: ["js", "ts"],
  transform: {
    "^.+\\.ts$": "ts-jest",
  },
  testMatch: ["<rootDir>/tests/index.spec.ts"],
  collectCoverage: true,
  collectCoverageFrom: ["<rootDir>/src/"],
  setupFilesAfterEnv: ["<rootDir>/tests/setupTests.ts"],
};
