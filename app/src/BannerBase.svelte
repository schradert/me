<script lang="ts">
  export let color: string;
  export let big: boolean = false;
</script>

<div class="banner {big ? 'big' : ''}" style={`background-color: ${color}`}>
  <slot></slot>
</div>

<style>
  .banner {
    width: clamp(360px, 100%, 720px);

    display: flex;
    flex-direction: column;
    justify-content: space-evenly;
    align-items: center;
    gap: 2rem;

    padding: 2%;

    flex: 1;
  }

  .banner.big {
    /* max-height: 85vh; */
    width: 100%;
    flex-direction: row;
    align-items: flex-start;
    flex-wrap: wrap;
    gap: 1rem;
  }

  @media screen and (max-width: 1326px) and (min-width: 990px) {
    .banner.big {
      justify-content: space-between;
    }
  }
</style>