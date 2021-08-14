<script lang="ts">
  export let color;
</script>

<div class="banner" style={`background-color: ${color}`}>
  <slot>
    Why you no put content here ehhh
  </slot>
</div>

<style>
  .banner {
    width: clamp(360px, 30vw, 500px);

    display: flex;
    flex-direction: column;
    justify-content: space-evenly;
    align-items: center;
    gap: 2rem;

    padding: 5%;
    /* margin: auto; */
  }
</style>