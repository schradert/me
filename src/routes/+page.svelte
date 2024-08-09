<script lang="ts">
import AppBar from "$lib/components/AppBar.svelte"
import BannerBase from "$lib/components/BannerBase.svelte"
import BannerConnector from "$lib/components/BannerConnector.svelte"
import ContactForm from "$lib/components/ContactForm.svelte"
import Profile from "$lib/components/Profile.svelte"
import Project from "$lib/components/Project.svelte"
import store, { viewport } from "$lib/store"

let showMore = false
let section = "projects"
</script>

<main>
  {#if $viewport.width < 720}
    <BannerBase color="#1F344A">
      <Profile />
    </BannerBase>
    <BannerConnector tailColor="#1F344A" headColor="#FBB500" title="projects" />
    <BannerBase color="#FBB500">
      <Project {...$store.projects.canivete} big />
      {#if showMore}
        <Project {...$store.projects.couchers} big />
        <Project {...$store.projects.alexandria} big />
        <Project {...$store.projects.dotfiles} big />
        <Project {...$store.projects.sage} big />
        <Project {...$store.projects.vilf} big />
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
        src={$store.basic.resume}
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
  {:else}
    <div class="flex h-full w-full">
    <div class="flex flex-col justify-stretch w-[40%]">
      <BannerBase color="#1F344A">
        <Profile />
      </BannerBase>
      <AppBar bind:section />
    </div>
    <div class="w-[60%] h-full">
      {#if section === "projects"}
        <BannerBase color="#FBB500" big>
          <Project {...$store.projects.couchers} big />
          <Project {...$store.projects.canivete} big />
          <Project {...$store.projects.alexandria} big />
          <Project {...$store.projects.dotfiles} big />
          <Project {...$store.projects.sage} big />
          <Project {...$store.projects.vilf} big />
        </BannerBase>
      {:else if section === "resume"}
        <BannerBase color="#CD1D67" big>
          <iframe
            src={$store.basic.resume}
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
    </div>
  {/if}
</main>

<style>
  main {
    height: 100%;
    display: flex;
    flex-direction: column;
    justify-content: stretch;
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
