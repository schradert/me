<script lang="ts">
import { page } from "$app/stores"
import { Drawer } from "$lib/components"
</script>

{#each ["projects", "resume", "contact"] as route}
  {@const href = `/${route}`}
  <Drawer.Close asChild let:builder>
  <div
    use:builder.action {...builder}
    class="flex items-center justify-center text-3xl hover:cursor-pointer h-1/3 hover:underline hover:bg-red/80 {$page.url.pathname === href ? 'bg-red/60' : 'bg-red'}"
  >
    <a {href}>{route.toUpperCase()}</a>
  </div>
  </Drawer.Close>
{/each}
