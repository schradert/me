<script lang="ts">
  const links = {
    work: [
      { name: "github", link: "https://github.com/schradert" },
      { name: "gitlab", link: "https://gitlab.com/schrader.tristan" },
      { name: "kaggle", link: "https://kaggle.com/tristanschrader" }
    ],
    contact: [
      { name: "email", link: "mailto:schrader.tristan@gmail.com" },
      { name: "linkedin", link: "https://www.linkedin.com/in/tristan-schrader-6b6b3a95/" }
    ]
  };
  const name = "Tristan Schrader";
  const intro = "I like to build things.\nBrowse the things I’ve learned to build.\nData Engineer.";

  async function getRandomAvatar(): Promise<string> {
    const response = await fetch("/avatarImages.json");
    const images = await response.json();
    return images[Math.floor(Math.random() * images.length)];
  }

</script>

<div class="banner">
  <div class="banner__box">
    <div class="banner__links">
      {#each links.work as { name, link }, i (i)}
      <a class="banner__icon" href={link}>
        <img src={`/icon/${name}.svg`} alt="Tristan's {name} profile">
      </a>
      {/each}
    </div>
    {#await getRandomAvatar() then src}
    <div 
      class="avatar" 
      style="background-image: url(/img/avatar/{src})" />
    {/await}
    <div class="banner__links banner__contact">
      {#each links.contact as { name, link }, i (i)}
      <a class="banner__icon" href={link}>
        <img src={`/icon/${name}.svg`} alt="Tristan's {name} profile">
      </a>
      {/each}
    </div>
  </div>
  <p class="title">{name}</p>
  <p class="description">{intro}</p>
</div>
<div class="banner__tail"></div>


<style>

  .banner {
    background-color: #1F344A;
    width: clamp(360px, 30vw, 500px);

    display: flex;
    flex-direction: column;
    justify-content: space-evenly;
    align-items: center;

    margin: auto;
  }

  .banner > * {
    margin: 2% 0;
  }

  .banner__tail {
    clip-path: polygon(0% 0%, 100% 0%, 50% 100%);
    width: clamp(360px, 30vw, 500px);
    height: 150px;
    background-color: #1F344A;
    margin: auto;
  }

  @media (min-width: 720px) {
    .banner, .banner__tail {
      margin-left: 200px;
    }
  }

  .banner__box {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 100%;
    gap: 5%;
  }

  .banner__links {
    display: flex;
    flex-direction: column;
    align-items: center;
  }

  .banner__contact .banner__icon {
    border-radius: 0%;
  }

  .banner__icon {
    border-radius: 50%;
    margin: 5% 0;
    padding: 2px;
    height: 50px;
    width: 50px;

    display: flex;
    align-items: center;
    justify-content: center;
  }
  .banner__icon:hover {
    background-color: #D0D4CF;
  }

  .avatar {
    border-radius: 50%;
    background-position: center;
    background-size: cover;
    min-width: 10rem;
    min-height: 10rem;
  }

  .title {
    font-size: 36px;

    color: whitesmoke;
  }

  .description {
    font-size: 14px;
    white-space: pre-line;

    color: whitesmoke;
  }
</style>