<script lang="ts">
import Project from "./Project.svelte"

const projects = {
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
}
</script>

<div class="flex flex-wrap justify-evenly content-evenly gap-4 h-full">
  {#each Object.values(projects) as project}
    <Project {...project} />
  {/each}
</div>
