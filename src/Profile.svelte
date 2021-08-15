<script lang="ts">
  import { profiles, full_name, short_bio, avatar } from './store';

</script>

<div class="banner__box">
  <div class="banner__links">
    {#each $profiles.work as { name, link }, i (i)}
    <a class="banner__icon" href={link}>
      <img src={`/icon/${name}.svg`} alt="Tristan's {name} profile">
    </a>
    {/each}
  </div>
  <div 
    class="avatar" 
    style="background-image: url(/img/avatar/{$avatar})" />
  <div class="banner__links banner__contact">
    {#each $profiles.contact as { name, link }, i (i)}
    <a class="banner__icon" href={link}>
      <img src={`/icon/${name}.svg`} alt="Tristan's {name} profile">
    </a>
    {/each}
  </div>
</div>
<p class="title">{$full_name}</p>
<p class="description">{$short_bio}</p>


<style>
  .banner__box {
    display: flex;
    align-items: center;
    justify-content: center;
    width: 100%;
    gap: 5%;
  }

  .banner__links {
    display: flex;
    flex-direction: column;
    align-items: center;
  }

  .banner__contact .banner__icon {
    border-radius: 0%;
  }

  .banner__icon {
    border-radius: 50%;
    margin: 5% 0;
    padding: 2px;
    height: 50px;
    width: 50px;

    display: flex;
    align-items: center;
    justify-content: center;
  }
  .banner__icon:hover {
    background-color: #D0D4CF;
  }

  .avatar {
    border-radius: 50%;
    background-position: center;
    background-size: cover;
    min-width: 10rem;
    min-height: 10rem;
  }

  .title {
    font-size: 36px;
    margin: 2% 0;

    color: whitesmoke;
  }

  .description {
    font-size: 14px;
    white-space: pre-line;
    margin: 2% 0;

    color: whitesmoke;
  }
</style>