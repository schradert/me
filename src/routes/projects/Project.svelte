<script lang="ts">
export let name: string
export let description: string
export let img: string
export let repoUrl: string
export let tags: string[]
export let big = false
</script>

<div class="max-w-[400px] py-4">
  <a href={repoUrl} target="_blank" class="title flex items-center gap-4 text-3xl text-black group hover:decoration-black hover:underline">
    <img src="/icon/{img}" class="h-[48px] w-[48px] p-1 group-hover:bg-[#1F344A] rounded-md" />
    {name}
  </a>
  <p>{description}</p>
  <div class="flex flex-wrap gap-2 mt-2">
    {#each tags as tag}
      <div class="rounded-full bg-red px-2 py-1">{tag}</div>
    {/each}
  </div>
</div>
