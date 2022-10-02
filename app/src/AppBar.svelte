<script lang="ts">
  export let categories = ["Projects", "Resume", "Contact"];
  export let section: string;
  export let big: boolean = false;
</script>

<div class="bar {big ? 'big' : ''}">
  {#each categories as cat, i (i)}
  <button 
    class="bar__button {section === cat.toLowerCase() ? 'selected' : ''}" 
    on:click={() => section = cat.toLowerCase()}
  >{cat}</button>
  {/each}
</div>

<style>
  .bar {
    display: flex;
    flex-direction: column;
    font-size: 36px;

    width: 50%;
  }

  @media (min-width: 1440px) {
    .bar {
      flex-grow: 1;
    }
  }

  .bar.big {
    flex-direction: row;
    align-items: flex-start;
  }

  .bar.big .bar__button {
    height: min-content;
  }

  .bar__button {
    /* width: 220px;
    height: 120px; */
    background-color: rgba(170, 65, 65, 0.75); /* #AA4141 */
    
    color: var(--black);

    display: flex;
    align-items: center;
    justify-content: center;

    height: 100%;
    width: 100%;
    border: none;
    border-radius: 0;
    margin: 0 0;
    cursor: pointer;
  }

  .bar__button.selected {
    color: var(--white);
    background-color: rgba(170, 65, 65, 1); /* #AA4141 */
  }
</style>