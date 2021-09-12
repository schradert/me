<script lang="ts">
  import Profile from "./Profile.svelte";
  import BannerConnector from "./BannerConnector.svelte";
  import BannerBase from "./BannerBase.svelte";
  import Project from "./Project.svelte";
  import ContactForm from "./ContactForm.svelte";

  import { projects, viewport, resume, bg } from "./store";
  import AppBar from "./AppBar.svelte";

  let showMore: boolean = false;
  let section: string = "projects";
</script>

<main style={$viewport.width > 1080 ? `background-image: url(${$bg})` : ""}>
  {#if $viewport.width < 720}
    <BannerBase color="#1F344A">
      <Profile />
    </BannerBase>
    <BannerConnector tailColor="#1F344A" headColor="#FBB500" title="projects" />
    <BannerBase color="#FBB500">
      <Project {...$projects.podra} />
      {#if showMore}
        <Project {...$projects.flabyrinth} />
        <Project {...$projects.edu_az} />
        <Project {...$projects.electric_hive} />
      {:else}
        <button class="more__projects" on:click={() => (showMore = true)}
          >Load more projects ...</button
        >
      {/if}
    </BannerBase>
    <BannerConnector
      tailColor="#FBB500"
      headColor="#CD1D67"
      title="resume"
      titleColor="black"
    />
    <BannerBase color="#CD1D67">
      <iframe
        src={$resume.url}
        frameborder="0"
        title=""
        width="100%"
        id="resume"
      />
    </BannerBase>
    <BannerConnector tailColor="#CD1D67" headColor="#5CA1D3" title="contact" />
    <BannerBase color="#5CA1D3">
      <ContactForm />
    </BannerBase>
  {:else if $viewport.width < 1440}
    <div class="top">
      <BannerBase color="#1F344A">
        <Profile />
      </BannerBase>
      <AppBar bind:section />
    </div>
    {#if section === "projects"}
      <BannerBase color="#FBB500" big>
        <Project {...$projects.podra} big />
        <Project {...$projects.flabyrinth} big />
        <Project {...$projects.edu_az} big />
        <Project {...$projects.electric_hive} big />
      </BannerBase>
    {:else if section === "resume"}
      <BannerBase color="#CD1D67" big>
        <iframe
          src={$resume.url}
          frameborder="0"
          title=""
          width="100%"
          id="resume"
        />
      </BannerBase>
    {:else}
      <BannerBase color="#5CA1D3" big>
        <ContactForm />
      </BannerBase>
    {/if}
  {:else}
    <div class="top">
      <div class="banner__box">
        <BannerBase color="#1F344A">
          <Profile />
        </BannerBase>
        <BannerConnector tailColor="#1F344A" />
      </div>
      <AppBar bind:section big />
    </div>
    <div class="content__box">
      {#if section === "projects"}
        <BannerBase color="#FBB500" big>
          <Project {...$projects.podra} big />
          <Project {...$projects.flabyrinth} big />
          <Project {...$projects.edu_az} big />
          <Project {...$projects.electric_hive} big />
        </BannerBase>
      {:else if section === "resume"}
        <BannerBase color="#CD1D67" big>
          <iframe
            src={$resume.url}
            frameborder="0"
            title=""
            width="100%"
            id="resume"
          />
        </BannerBase>
      {:else}
        <BannerBase color="#5CA1D3" big>
          <ContactForm />
        </BannerBase>
      {/if}
    </div>
  {/if}
</main>

<style>
  main {
    height: 100%;
    display: flex;
    flex-direction: column;
    justify-content: stretch;

    background-size: cover;
    background-repeat: no-repeat;
    background-position: center;
  }

  .content__box {
    position: absolute;
    border-radius: 10%;
    width: calc(100vw - 500px - 10% - 25px);
    height: calc(100vh - 10%);
    left: calc(500px + 10%);
    top: 7%;
    padding: 25px;
  }

  .banner__box {
    width: 500px;
    margin-left: 10%;
  }

  .top {
    display: flex;
    justify-content: stretch;
    position: relative;
  }

  .more__projects {
    width: 60%;
    display: block;
    border-radius: 500px;
    margin: 5px auto;
    border: 1px solid var(--black);
    background-color: #3cd921;
    cursor: pointer;
  }
  .more__projects:hover {
    box-shadow: 1px 1px 2px 2px var(--black);
  }

  #resume {
    height: clamp(420px, 110vw, 80vh);
  }
</style>
