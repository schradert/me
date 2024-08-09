import { readable } from "svelte/store"

function getViewport(): { width: number; height: number } {
  const width = Math.max(document.documentElement.clientWidth || 0, window.innerWidth || 0)
  const height = Math.max(document.documentElement.clientHeight || 0, window.innerHeight || 0)
  return { width, height }
}

export const viewport = readable(getViewport(), set => {
  const setViewport = () => set(getViewport());
  window.addEventListener("resize", setViewport)
  return () => window.removeEventListener("resize", setViewport)
})

export default readable({
  basic: {
    name: "Tristan Schrader",
    bio: "Data Platform Engineer\nOpen Source Contributor\nHomelab Hobbyist",
    avatar: "https://lh3.googleusercontent.com/d/1nKXg17IuS3PARUcMXzi7EVh3dUUvZJhh",
    resume: "https://drive.google.com/file/d/1T9Vy9mUjaS6GLKzKcjzOh8Y7Y4IWrshN/preview",
  },
  profiles: {
    work: [
      { name: "github", link: "https://github.com/schradert" },
      { name: "gitlab", link: "https://gitlab.com/schrader.tristan" },
      { name: "kaggle", link: "https://kaggle.com/tristanschrader" },
    ],
    contact: [
      { name: "email", link: "mailto:tristanschrader@pm.me" },
      { name: "linkedin", link: "https://www.linkedin.com/in/tristan-schrader-6b6b3a95/" },
    ],
  },
  projects: {
    couchers: {
      name: "Couchers",
      description: "Next-generation couchsurfing platform with 40k strong user base.",
      img: "couchers.svg",
      repoUrl: "https://github.com/couchers-org/couchers",
      tags: ["gRPC", "SQLAlchemy", "NextJS", "PostGIS", "Docker"],
    },
    canivete: {
      name: "Canivete",
      description: "Repository framework for developing, packaging, and deploying Nix packages.",
      img: "nix.svg",
      repoUrl: "https://github.com/schradert/canivete",
      tags: ["Nix", "NixOS", "Kubernetes", "OpenTofu", "Podman"],
    },
    alexandria: {
      name: "Alexandria",
      description: "Multimedia library manager and habit tracker for desktop.",
      img: "bunkbed.png",
      repoUrl: "https://gitlab.com/bunkbed/alexandria",
      tags: ["Rust", "PostgreSQL", "SvelteKit", "Tauri", "Docker"],
    },
    dotfiles: {
      name: "Dotfiles",
      description: "Declarative configuration of all personal devices and homelab.",
      img: "nix.svg",
      repoUrl: "https://github.com/schradert/dotfiles",
      tags: ["canivete", "Linux", "Darwin", "Windows", "Android"],
    },
    sage: {
      name: "Sage",
      description: "R&D process design and data entry tool with graph networks.",
      img: "xyflow.ico",
      repoUrl: "https://github.com/schradert/sage",
      tags: ["canivete", "SvelteKit", "SurrealDB", "Xyflow", "FastAPI"],
    },
    vilf: {
      name: "VILF",
      description: "Vegans In Love with Food: vegan food blog with a map!",
      img: "vilf.png",
      repoUrl: "https://github.com/ItsiW/VILF",
      tags: ["canivete", "Python", "Markdown", "GCP", "Selenium"],
    },
  },
})
