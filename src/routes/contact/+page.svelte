<script lang="ts">
import { Button } from "$lib/components/ui/button"
import { email } from "$lib/data"

let message = ""
let subject = ""

function handleSubmit(): void {
  window.open(`mailto:${email}?subject=${subject}&body=${message}`)
  message = ""
  subject = ""
}
</script>

<form on:submit|preventDefault={handleSubmit} class="flex flex-col gap-4 w-[50%] text-xl">
  <div class="flex gap-4 items-center">
    <label for="subject">Subject</label>
    <input type="text" name="subject" bind:value={subject} class="w-full bg-red/60 p-2 text-l rounded-md">
  </div>
  <textarea
    placeholder="Please write your message here."
    bind:value={message}
    class="placeholder:text-black/80 rounded-md resize-none w-full p-2 text-l text-black bg-red/60 aspect-[2/1] min-h-[200px]"
  />
  <Button
    type="submit"
    class="bg-blue hover:bg-red/80 text-white hover:text-black p-2 w-auto rounded-md border-blue border-4"
  >
    Open in Email
  </Button>
</form>
