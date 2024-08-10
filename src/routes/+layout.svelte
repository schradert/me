<script lang="ts">
import { page } from "$app/stores"
import { Drawer, Sidebar } from "$lib/components"
import { Menu } from "lucide-svelte"

import "../app.css"
</script>

<div class="flex h-screen w-screen overflow-hidden">
  <Drawer.Root direction="left">
    <Drawer.Content class="h-full w-[90%] rounded-none rounded-r-lg overflow-hidden border-none">
      <Sidebar class="flex h-full bg-white" />
    </Drawer.Content>
    <Sidebar class="sm:flex hidden w-[40%]" />
    <div class="w-full h-full bg-yellow sm:w-[60%] p-4 flex flex-col items-center justify-start overflow-y-auto">
      <div class="sticky -top-4 bg-yellow flex w-full items-center sm:hidden">
        <div class="flex items-center w-1/3 h-full">
          <Drawer.Trigger>
            <div class="hover:bg-blue hover:cursor-pointer hover:text-white p-2 rounded-md"><Menu /></div>
          </Drawer.Trigger>
        </div>
        <div class="flex justify-center items-center w-1/3 h-full">
          <h1 class="text-3xl">{$page.url.pathname.toUpperCase().slice(1)}</h1>
        </div>
      </div>
      <div class="h-full w-full items-center justify-center content-center flex flex-col">
        <slot />
      </div>
    </div>
  </Drawer.Root>
</div>

<style>
/* Don't know why Shadcn adds this useless buffer, makes it look ugly... */
:global([data-vaul-drawer] > :first-child) {
  display: none;
}
</style>
