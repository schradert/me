import { readable } from 'svelte/store';



function getViewport(): { width: number, height: number } {
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

export const viewport = readable(getViewport(), set => {
  function setViewport(): void {
    set(getViewport());
  }

  window.addEventListener("resize", setViewport);

  return function remove() {
    window.removeEventListener("resize", setViewport);
  }
});



export const profiles = readable({
  work: [
    { name: "github", link: "https://github.com/schradert" },
    { name: "gitlab", link: "https://gitlab.com/schrader.tristan" },
    { name: "kaggle", link: "https://kaggle.com/tristanschrader" }
  ],
  contact: [
    { name: "email", link: "mailto:schrader.tristan@gmail.com" },
    { name: "linkedin", link: "https://www.linkedin.com/in/tristan-schrader-6b6b3a95/" }
  ]
});


async function getRandomAvatar(): Promise<string> {
  const response = await fetch("/avatarImages.json");
  const images = await response.json();
  return images[Math.floor(Math.random() * images.length)];
}

export const avatar = readable("default.png", set => {
  const interval = setInterval(async () => {
    set(await getRandomAvatar());
  }, 10000);

  return function stop() {
    clearInterval(interval);
  }
});

export const full_name = readable("Tristan Schrader");
export const short_bio = readable("I like to build things.\nBrowse the things I’ve learned to build.\nData Engineer.");



export const projects = readable({
  podra: {
    name: "Podra",
    description: "Keep up with highlights from internet communities with Podra, your web desktop with newsboard analytics.",
    img: "/img/projects/podra.webp",
    repoUrl: "https://github.com/schradert/podra",
    tags: ["kafka", "spark", "airflow", "kubernetes", "terraform"]
  },
  flabyrinth: {
    name: "Flabyrinth",
    description: "Flabyrinth is a security-driven, content management platform and media sharing service for Terrace F. Club.",
    img: "/img/projects/flabyrinth.webp",
    repoUrl: "https://gitlab.com/terrace/tech/tfc-website",
    tags: ["django", "postgres", "vanillajs", "terraform", "gitlab", "redis", "google cloud platform"]
  },
  edu_az: {
    name: "az.edu",
    description: "Secondary education in a nutshell. Evaluate for yourself the achievements and challenges of Arizona public schools.",
    img: "/img/projects/edu_az.webp",
    repoUrl: "https://github.com/schradert/az.edu",
    tags: ["bigquery", "sql", "pytorch", "sklearn", "pandas"]
  },
  electric_hive: {
    name: "Electric Hive",
    description: "Electric Hive is an international programmer collective with opportunities for mentorship and collaboration in all IT.",
    img: "/img/projects/electric_hive.webp",
    repoUrl: "https://github.com/tomstrat/hive-website",
    tags: ["gatsby", "react", "github actions"]
  },
})