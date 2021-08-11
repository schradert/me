module.exports = {
  moduleFileExtensions: ['ts', 'svelte'],
  transform: {
    '^.+\\.svelte$': 'svelte-jester',
    '^.+\\.ts$': 'ts-jest',
  },
  collectCoverage: true,
  collectCoverageFrom: [
    '<rootDir>/src/',
  ],
  setupFilesAfterEnv: [
    '<rootDir>/tests/setupTests.ts'
  ]
}
