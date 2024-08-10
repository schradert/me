{nix, ...}: {
  perSystem = {
    pkgs,
    self',
    ...
  }: {
    packages.bun = pkgs.bun;
    canivete.dream2nix.packages = {
      app-node_modules.module = {
        config,
        dream2nix,
        ...
      }: {
        imports = [dream2nix.modules.dream2nix.mkDerivation];
        paths.package = ../.;
        deps = {nixpkgs, ...}: {
          inherit (nixpkgs) bun;
        };
        name = "app-node_modules";
        version = "0.0.1";
        mkDerivation = {
          src = ../.;
          nativeBuildInputs = [config.deps.bun];
          buildPhase = "bun install --no-progress --frozen-lockfile";
          installPhase = ''
            mkdir -p $out/node_modules
            cp -R ./node_modules $out
          '';
          # Playwright has shebangs that get patched and break FOD
          dontPatchShebangs = true;
          outputHash = "vtJn6ksZlQf/0waRmKCemyefJQaFDERDWmD2mu7c+RU=";
          outputHashAlgo = "sha256";
          outputHashMode = "recursive";
        };
      };
      app.module = {
        config,
        dream2nix,
        ...
      }: {
        imports = [dream2nix.modules.dream2nix.mkDerivation];
        paths.package = ../.;
        deps = {nixpkgs, ...}: {
          inherit (nixpkgs) bun makeBinaryWrapper;
        };
        name = "app";
        version = "0.0.1";
        mkDerivation = {
          src = ../.;
          nativeBuildInputs = [config.deps.makeBinaryWrapper];
          buildInputs = [config.deps.bun];
          buildPhase = ''
            ln -s ${self'.packages.app-node_modules}/node_modules ./node_modules
            bun run build
          '';
          installPhase = ''
            mkdir -p $out/bin
            cp -R ./build/* $out
            makeBinaryWrapper ${nix.getExe config.deps.bun} $out/bin/app --add-flags "x http-server $out"
          '';
        };
      };
    };
    canivete.process-compose.services.settings.processes.app.command = let
      bun = nix.getExe self'.packages.bun;
    in "${bun} install && ${bun} dev";
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
