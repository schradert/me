<script lang="ts">
  let message: string;
  let subject: string;

  function handleSubmit(): void {
    window.open(`mailto:schrader.tristan@gmail.com?subject=${subject}&body=${message}`);
    message = "";
    subject = "";
  }
</script>

<div class="form__wrapper">
  <form class="form__box" on:submit|preventDefault={handleSubmit}>
    <div class="control">
      <label for="subject">Subject</label>
      <input type="text" id="subject" name="subject" bind:value={subject}>
    </div>
    <textarea name="message" id="message" placeholder="Please write your message here." bind:value={message}></textarea>
    <button class="form__submit" type="submit">Send Email</button>
  </form>
</div>

<style>
  * {
    font-size: 14px;
  }

  input {
    flex-grow: 1;
  }

  input, textarea {
    background-color: #C4C4C4;
    border-radius: 10px;
    padding: 8px;
    margin: 0 0;
  }

  label {
    width: 20%;
  }

  textarea {
    resize: none;
    width: 100%;
    aspect-ratio: 3 / 1;
  }

  .form__wrapper {
    width: 100%;
    display: flex;
    justify-content: center;
  }

  .form__box {
    width: 80%;
    max-width: 750px;
    margin: 2em 0;
    justify-self: center;
  }

  .control, textarea {
    margin-bottom: 8px;
  }

  .control {
    display: flex;
    align-items: center;
    width: 100%;
    gap: 1em;
  }

  .form__submit {
    width: 60%;
    display: block;
    border-radius: 500px;
    margin: 5px auto;
    border: 1px solid var(--black);
    background-color: #3CD921;
    cursor: pointer;
  }

  .form__submit:hover {
    box-shadow: 1px 1px 2px 2px var(--black);
  }
</style>