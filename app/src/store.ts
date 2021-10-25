import { readable } from "svelte/store";

function getViewport(): { width: number; height: number } {
  const width = Math.max(
    document.documentElement.clientWidth || 0,
    window.innerWidth || 0
  );
  const height = Math.max(
    document.documentElement.clientHeight || 0,
    window.innerHeight || 0
  );
  return { width, height };
}

export const viewport = readable(getViewport(), (set) => {
  function setViewport(): void {
    set(getViewport());
  }

  window.addEventListener("resize", setViewport);

  return function remove() {
    window.removeEventListener("resize", setViewport);
  };
});

export const profiles = readable({
  work: [
    { name: "github", link: "https://github.com/schradert" },
    { name: "gitlab", link: "https://gitlab.com/schrader.tristan" },
    { name: "kaggle", link: "https://kaggle.com/tristanschrader" },
  ],
  contact: [
    { name: "email", link: "mailto:schrader.tristan@gmail.com" },
    {
      name: "linkedin",
      link: "https://www.linkedin.com/in/tristan-schrader-6b6b3a95/",
    },
  ],
});

type StorageObject = { name: string; mediaLink: string };
const listUrl =
  "https://storage.googleapis.com/storage/v1/b/sandbox_main_bucket/o";
async function getRandomImage(imageType: string): Promise<StorageObject> {
  const allImages: StorageObject[] = (
    await fetch(listUrl).then((res) => res.json())
  ).items.map((item: StorageObject) => ({
    name: item.name,
    mediaLink: item.mediaLink,
  }));
  const images = allImages.filter(
    (img) =>
      img.name.includes(`portfolio/${imageType}/`) &&
      !img.name.includes("default")
  );
  return images[Math.floor(Math.random() * images.length)];
}

function getImageUrl(imageType: string, name: string): string {
  return `https://storage.googleapis.com/sandbox_main_bucket/portfolio/${imageType}/${name}.webp`;
}

function getDefaultImageUrl(imageType: string): string {
  return getImageUrl(imageType, "default");
}

function getProjectUrl(name: string): string {
  return getImageUrl("project", name);
}

function asReadableStore({ imageType }: { imageType: string }) {
  return readable(getDefaultImageUrl(imageType), (set) => {
    const interval = setInterval(async () => {
      set((await getRandomImage(imageType)).mediaLink);
    }, 30000);

    return function stop() {
      clearInterval(interval);
    };
  });
}

export const avatar = asReadableStore({ imageType: "avatar" });
export const bg = asReadableStore({ imageType: "bg" });
export const resume = readable({
  url: "https://storage.googleapis.com/sandbox_main_bucket/portfolio/resume.pdf",
});

export const full_name = readable("Tristan Schrader");
export const short_bio = readable(
  "Tristan's the name.\nData's the game."
);

export const bucketUrlPrefix =
  "https://storage.googleapis.com/sandbox_main_bucket/portfolio";
export const projects = readable({
  podra: {
    name: "Podra",
    description:
      "Keep up with highlights from internet communities with Podra, your web desktop with newsboard analytics.",
    img: getProjectUrl("podra"),
    repoUrl: "https://github.com/schradert/podra",
    tags: ["kafka", "spark", "airflow", "kubernetes", "terraform"],
  },
  flabyrinth: {
    name: "Flabyrinth",
    description:
      "Flabyrinth is a security-driven, content management platform and media sharing service for Terrace F. Club.",
    img: getProjectUrl("flabyrinth"),
    repoUrl: "https://gitlab.com/terrace/tech/tfc-website",
    tags: [
      "django",
      "postgres",
      "vanillajs",
      "terraform",
      "gitlab",
      "redis",
      "google cloud platform",
    ],
  },
  edu_az: {
    name: "az.edu",
    description:
      "Secondary education in a nutshell. Evaluate for yourself the achievements and challenges of Arizona public schools.",
    img: getProjectUrl("edu_az"),
    repoUrl: "https://github.com/schradert/az.edu",
    tags: ["bigquery", "sql", "pytorch", "sklearn", "pandas"],
  },
  electric_hive: {
    name: "Electric Hive",
    description:
      "Electric Hive is an international programmer collective with opportunities for mentorship and collaboration in all IT.",
    img: getProjectUrl("electric_hive"),
    repoUrl: "https://github.com/tomstrat/hive-website",
    tags: ["gatsby", "react", "github actions"],
  },
});
