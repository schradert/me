<script lang="ts">
  export let tailColor: string;
  export let headColor: string = null;
  export let title: string = "";
  export let titleColor: string = "white";
  $: titleCapital = title.toUpperCase();
</script>

<div class="box" style={headColor ? 'background-color: #343434' : ''}>
  <div class="banner__tail" style={`background-color: ${tailColor}`}></div>
  {#if headColor}
  <div class="next" style={`color: var(--${titleColor})`}>
    <p class="title">{titleCapital}</p>
    <svg viewBox="0 0 36 36">
      <use xlink:href="/icon/doubledown.svg#doubledown"></use>
    </svg>
  </div>
  <div class="banner__head" style={`background-color: ${headColor}`}></div>
  {/if}
</div>


<style>
  .box {
    position: relative;
    width: clamp(360px, 100%, 720px);
    min-height: 150px;
  }

  .box > * {
    position: absolute;
    inset: 0;
    margin: auto;
  }

  .next {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;

    padding-bottom: 2em;

    fill: currentColor;
  }

  .title {
    font-size: 36px;
    margin: 2% 0;

    color: inherit;
  }

  .banner__tail {
    clip-path: polygon(0% 0%, 100% 0%, 50% 100%);
    width: clamp(360px, 100%, 720px);
    height: 145px;
    margin-bottom: 5px;
  }

  .banner__head {
    clip-path: polygon(0% 0%, 50% 100%, 100% 0%, 100% 100%, 0% 100%);
    width: clamp(360px, 100%, 720px);
    height: 145px;
    margin-top: 5px;
  }
</style>