const js = require("@eslint/js");
const globals = require("globals");

module.exports = [
  {
    files: ["**/*.js"],
    languageOptions: {
      ecmaVersion: 2020,
      sourceType: "commonjs",
      globals: {
        ...globals.node
      }
    },
    rules: {
      ...js.configs.recommended.rules,
      quotes: ["error", "double"],
      "max-len": ["error", {code: 80}],
      indent: ["error", 2],
      "object-curly-spacing": ["error", "never"],
      "eol-last": ["error", "always"]
    }
  }
];
