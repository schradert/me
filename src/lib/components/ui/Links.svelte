<script lang="ts">
type Link = {
  name: string
  link: string
}
export let links: Link[]
</script>

<div class="links">
  {#each links as { name, link }}
    <a href={link} class="hover:bg-yellow p-2 rounded-full w-[48px] h-[48px] flex items-center justify-center">
      <img src="/icon/{name}.svg" />
    </a>
  {/each}
</div>

<style lang="postcss">
.links {
  @apply flex flex-col justify-evenly items-center gap-2;
}
</style>
