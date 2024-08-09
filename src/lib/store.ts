import { readable } from "svelte/store"

function getViewport(): { width: number; height: number } {
  const width = Math.max(document.documentElement.clientWidth || 0, window.innerWidth || 0)
  const height = Math.max(document.documentElement.clientHeight || 0, window.innerHeight || 0)
  return { width, height }
}

export const viewport = readable(getViewport(), set => {
  function setViewport(): void {
    set(getViewport())
  }

  window.addEventListener("resize", setViewport)

  return function remove() {
    window.removeEventListener("resize", setViewport)
  }
})

export const profiles = readable({
  work: [
    { name: "github", link: "https://github.com/schradert" },
    { name: "gitlab", link: "https://gitlab.com/schrader.tristan" },
    { name: "kaggle", link: "https://kaggle.com/tristanschrader" },
  ],
  contact: [
    { name: "email", link: "mailto:tristanschrader@pm.me" },
    {
      name: "linkedin",
      link: "https://www.linkedin.com/in/tristan-schrader-6b6b3a95/",
    },
  ],
})

type StorageObject = { name: string; mediaLink: string }
const listUrl = "https://storage.googleapis.com/storage/v1/b/sandbox_main_bucket/o"
async function getRandomImage(imageType: string): Promise<StorageObject> {
  const allImages: StorageObject[] = (await fetch(listUrl).then(res => res.json())).items.map(
    (item: StorageObject) => ({
      name: item.name,
      mediaLink: item.mediaLink,
    }),
  )
  const images = allImages.filter(img => img.name.includes(`portfolio/${imageType}/`) && !img.name.includes("default"))
  return images[Math.floor(Math.random() * images.length)]
}

function getImageUrl(imageType: string, name: string): string {
  return `https://storage.googleapis.com/sandbox_main_bucket/portfolio/${imageType}/${name}.webp`
}

function getDefaultImageUrl(imageType: string): string {
  return getImageUrl(imageType, "default")
}

function getProjectUrl(name: string): string {
  return getImageUrl("project", name)
}

function asReadableStore({ imageType }: { imageType: string }) {
  return readable(getDefaultImageUrl(imageType), set => {
    const interval = setInterval(async () => {
      set((await getRandomImage(imageType)).mediaLink)
    }, 30000)

    return function stop() {
      clearInterval(interval)
    }
  })
}

export const avatar = asReadableStore({ imageType: "avatar" })
export const bg = asReadableStore({ imageType: "bg" })
export const resume = readable({ url: "https://drive.google.com/file/d/1T9Vy9mUjaS6GLKzKcjzOh8Y7Y4IWrshN/preview" })

export const full_name = readable("Tristan Schrader")
export const short_bio = readable("Data Platform Engineer\nOpen Source Contributor\nHomelab Hobbyist")

export const bucketUrlPrefix = "https://storage.googleapis.com/sandbox_main_bucket/portfolio"
export const projects = readable({
  couchers: {
    name: "Couchers",
    description: "Next-generation couchsurfing platform.",
    img: getProjectUrl("couchers"),
    repoUrl: "https://github.com/couchers-org/couchers",
    tags: ["gRPC", "SQLAlchemy", "NextJS", "PostGIS", "Docker"],
  },
  canivete: {
    name: "Canivete",
    description: "Repository framework for developing, packaging, and deploying Nix packages to Kubernetes clusters managed with OpenTofu.",
    img: getProjectUrl("canivete"),
    repoUrl: "https://github.com/schradert/canivete",
    tags: ["Nix", "NixOS", "Kubernetes", "OpenTofu", "Podman"],
  },
  alexandria: {
    name: "Alexandria",
    description: "Multimedia library manager and habit tracker.",
    img: getProjectUrl("alexandria"),
    repoUrl: "https://gitlab.com/bunkbed/alexandria",
    tags: ["Rust", "PostgreSQL", "SvelteKit", "Tauri", "Docker"],
  },
  dotfiles: {
    name: "Dotfiles",
    description: "Declarative configuration of all personal devices and homelab.",
    img: getProjectUrl("dotfiles"),
    repoUrl: "https://github.com/schradert/dotfiles",
    tags: ["canivete", "Linux", "Darwin", "Windows", "Android"],
  },
  sage: {
    name: "Sage",
    description: "Graph-based process design tool.",
    img: getProjectUrl("sage"),
    repoUrl: "https://github.com/schradert/sage",
    tags: ["canivete", "SvelteKit", "SurrealDB", "Xyflow", "FastAPI"],
  },
  vilf: {
    name: "VILF",
    description: "Vegans In Love with Food: vegan food blog with a map!",
    img: getProjectUrl("vilf"),
    repoUrl: "https://github.com/ItsiW/VILF",
    tags: ["canivete", "Python", "Markdown", "GCP", "Selenium"],
  },
})
