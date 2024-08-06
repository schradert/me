{nix, ...}: {
  perSystem = {
    canivete.pre-commit = {
      languages.javascript.enable = true;
      # Also run biome on .svelte files
      settings.hooks.biome.types_or = ["svelte"];
      settings.excludes = ["todo"];
      settings.hooks.lychee.settings.flags = nix.concatStringsSep " " [
        # TODO migrate to a different data store
        "--exclude storage.googleapis.com"
        # Remap sveltekit assets to correct folder for static link checking
        "--remap 'src/%25sveltekit.assets%25 static'"
      ];
    };
    canivete.kubenix.clusters.prod.modules.main.kubernetes.resources.deployments.spec = let
      labels.app = "me";
    in {
      replicas = 3;
      selector.matchLabels = labels;
      template.metadata.labels = labels;
      # TODO add docker container
      template.spec.containers.me.image = "";
    };
  };
}
