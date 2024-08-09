<script lang="ts">
export let name: string
export let description: string
export let img: string
export let repoUrl: string
export let tags: string[]
export let big = false

function openRepoUrl(): void {
  window.open(repoUrl, "_blank")
}
</script>

<div class="box {big ? 'big' : ''} w-[90%]">
  <a href={repoUrl} target="_blank" class="title flex items-center gap-4 group hover:decoration-black">
    <img src="/icon/{img}" class="h-[48px] w-[48px] p-1 group-hover:bg-[#1F344A]" />
    <h1 class="text-3xl text-black">{name}</h1>
  </a>
  <p class="description" on:click={openRepoUrl}>{description}</p>
  <div class="tag__box mt-2">
    {#each tags as tag}
      <div class="tag">{tag}</div>
    {/each}
  </div>
</div>

<style>
  .box.big {
    width: clamp(250px, 50%, 300px);
  }

  .description {
    font-size: 14px;
    white-space: pre-line;

    color: var(--black);
  }

  .description, .title {
    padding-left: 0.5rem;
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
