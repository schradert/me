{
  perSystem = {
    nix,
    pkgs,
    self',
    ...
  }: {
    packages.bun = pkgs.bun;
    process-compose.services.settings.processes.app.command = let
      bun = nix.getExe self'.packages.bun;
    in "${bun} install && ${bun} dev";
    pre-commit = {
      languages.javascript.enable = true;
      settings.excludes = ["todo"];
      settings.hooks = {
        # Also run biome on .svelte files
        biome.types_or = ["svelte"];
        # Allow arbitrary line length in markdown (paragraph wrapping preferred)
        markdownlint.settings.configuration.MD013.line_length = -1;
        # Remap sveltekit assets to correct folder for static link checking
        lychee.settings.flags = "--remap 'src/%25sveltekit.assets%25 static'";
      };
    };
  };
}
