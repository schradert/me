<script lang="ts">
import { email } from "$lib/data"

import Links from "./Links.svelte"

const left: Links["links"] = [
  { name: "github", link: "https://github.com/schradert" },
  { name: "gitlab", link: "https://gitlab.com/schrader.tristan" },
  { name: "kaggle", link: "https://kaggle.com/tristanschrader" },
]
const right: Links["links"] = [
  { name: "email", link: `mailto:${email}` },
  { name: "linkedin", link: "https://www.linkedin.com/in/tristan-schrader-6b6b3a95/" },
]
</script>

<div class="flex gap-4">
  <Links links={left} />
  <div class="avatar h-40 w-40" />
  <Links links={right} />
</div>
<p class="text-3xl">Tristan Schrader</p>
<p class="whitespace-pre-line">
  Data Platform Engineer
  Open Source Contributor
  Homelab Hobbyist
</p>

<style lang="postcss">
.avatar {
  @apply h-40 w-40;
  @apply rounded-full;
  @apply bg-cover;
  background-image: url("https://lh3.googleusercontent.com/d/1nKXg17IuS3PARUcMXzi7EVh3dUUvZJhh");
}
</style>
