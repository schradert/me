<script lang="ts">
import type { HTMLAttributes } from "svelte/elements"

import { cn } from "$lib/utils"

import Profile from "./Profile.svelte"
import Router from "./Router.svelte"

let className: HTMLAttributes<HTMLDivElement>["class"] = undefined
export { className as class }
</script>

<div class={cn("flex flex-col", className)}>
  <div class="bg-blue text-white flex flex-col justify-evenly items-center h-[50%]"><Profile /></div>
  <div class="flex flex-col items-stretch h-[50%]"><Router /></div>
</div>
