import typography from "@tailwindcss/typography"
import type { Config } from "tailwindcss"

const config: Config = {
  darkMode: ["class"],
  content: ["./src/**/*.svelte"],
  safelist: ["dark"],
  theme: {
    extend: {
      screens: {
        sm: "720px",
      },
      colors: {
        black: "hsl(var(--black) / <alpha-value>)",
        white: "hsl(var(--white) / <alpha-value>)",
        yellow: "hsl(var(--yellow) / <alpha-value>)",
        blue: "hsl(var(--blue) / <alpha-value>)",
        red: "hsl(var(--red) / <alpha-value>)",
      },
    },
  },
  plugins: [typography],
}

export default config
