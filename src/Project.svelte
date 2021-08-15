<script lang="ts">
  export let name: string;
  export let description: string;
  export let img: string;
  export let repoUrl: string;
  export let tags: string[];
  export let big: boolean = false;

  function openRepoUrl(): void {
    window.open(repoUrl, "_blank");
  }
</script>

<div class="box {big ? 'big' : ''}">
  <p class="title">{name}</p>
  <img src={img} 
    alt="{name} project display" 
    class="project__img" on:click={openRepoUrl}>
  <p class="description" on:click={openRepoUrl}>{description}</p>
  <div class="tag__box">
    {#each tags as tag}
      <div class="tag">{tag}</div>
    {/each}
  </div>
</div>

<style>
  .box {
    width: 90%;
  }

  .box.big {
    width: clamp(250px, 50%, 300px);
  }

  .title {
    font-size: 36px;
    margin: 0 auto 0.5rem;

    color: black;
  }

  .description {
    font-size: 14px;
    white-space: pre-line;

    color: black;
  }

  .description, .title {
    padding-left: 0.5rem;
  }

  .project__img {
    width: 100%;
    aspect-ratio: 14 / 9;
    border-radius: 10%;
  }

  .description, .project__img {
    cursor: pointer;
  }

  .tag__box {
    display: flex;
    flex-wrap: wrap;
    gap: 0.5rem;
  }

  .tag {
    font-size: 14px;
    background-color: #343434;
    color: #EFEFEF;
    padding: 5px 15px;
    border-radius: 500px;
  }
</style>
