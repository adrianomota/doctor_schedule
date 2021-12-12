module.exports = {
  mode: "jit",
  content: ["./js/**/*.js", "../lib/*_web/**/*.*ex"],
  theme: {
    extend: {
      colors: {
        "purple-main": "#2D46B9",
        "green-main": "#1ED760",
      },
    },
  },
  variants: {},
  plugins: [],
};