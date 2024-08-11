{nix, ...}: {
  perSystem = {
    config,
    pkgs,
    system,
    ...
  }: let
    node_modules = config.packages.app-node_modules;
  in {
    packages.bun = pkgs.bun;
    packages.arion = pkgs.arion;
    canivete = {
      arion.modules.main = {self'', ...}: {
        services.app.image.command = [(nix.getExe self''.packages.app)];
      };
      dream2nix.packages = {
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
            outputHash =
              {
                aarch64-darwin = "qa4lLiRBUXj2ACLLqFn4Au8B90yQaSpiTKkIs1G5KQw=";
                aarch64-linux = "nUR+slh9SV79mLXMrLt9w1Wh83fs6Xk1puKZOQDFtdw=";
              }
              .${system}
              or "";
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
            inherit (nixpkgs) bun makeBinaryWrapper nodejs-slim_latest;
          };
          name = "app";
          version = "0.0.1";
          mkDerivation = {
            src = ../.;
            nativeBuildInputs = [config.deps.makeBinaryWrapper];
            configurePhase = ''
              cp -R ${node_modules}/node_modules .
              substituteInPlace node_modules/.bin/vite \
                --replace "/usr/bin/env node" "${config.deps.nodejs-slim_latest}/bin/node"
            '';
            buildInputs = [config.deps.bun];
            buildPhase = "bun run build";
            installPhase = ''
              mkdir -p $out/bin
              cp -R ./build/* $out
              makeBinaryWrapper ${nix.getExe config.deps.bun} $out/bin/app --add-flags "x http-server $out"
            '';
            # TODO why doesn't this work?!
            meta.mainProgram = "app";
          };
        };
      };
      process-compose.services.settings.processes.app.command = let
        bun = nix.getExe config.packages.bun;
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
      kubenix.clusters.prod.modules.main.kubernetes.resources.deployments.spec = let
        labels.app = "me";
      in {
        replicas = 3;
        selector.matchLabels = labels;
        template.metadata.labels = labels;
        # TODO add docker container
        template.spec.containers.me.image = "";
      };
    };
  };
}
