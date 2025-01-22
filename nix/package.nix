{
  perSystem = {
    config,
    nix,
    system,
    ...
  }: let
    inherit (nix) getExe importJSON;
    inherit (importJSON ../package.json) name version;
    node_modules_name = "${name}-node_modules";
    node_modules = config.packages.${node_modules_name};
  in {
    canivete.dream2nix.packages = {
      ${node_modules_name}.module = {
        config,
        dream2nix,
        ...
      }: {
        imports = [dream2nix.modules.dream2nix.mkDerivation];
        paths.package = ../.;
        deps = {nixpkgs, ...}: {inherit (nixpkgs) bun;};
        name = node_modules_name;
        inherit version;
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
          # TODO avoid system-specific outputHashes
          # TODO get aarch64-linux build... (system currently broken)
          outputHash =
            {
              aarch64-darwin = "PSS/llTFXTxBuhzRFWui4Ngw3Qf5EzHaz8xUSKtGU4Q=";
              aarch64-linux = "";
              x86_64-linux = "IhVyWbN3dYgyXStoyYrOx1OD94rxFHsKeWOKZpvVf6I=";
            }
            .${system}
            or "";
          outputHashAlgo = "sha256";
          outputHashMode = "recursive";
        };
      };
      ${name}.module = {
        config,
        dream2nix,
        ...
      }: let
        inherit (config.deps) bun makeBinaryWrapper nodejs-slim_latest http-server;
      in {
        imports = [dream2nix.modules.dream2nix.mkDerivation];
        paths.package = ../.;
        deps = {nixpkgs, ...}: {inherit (nixpkgs) bun makeBinaryWrapper nodejs-slim_latest http-server;};
        inherit name version;
        mkDerivation = {
          src = ../.;
          nativeBuildInputs = [bun makeBinaryWrapper];
          buildInputs = [http-server];
          configurePhase = ''
            cp -R ${node_modules}/node_modules .
            substituteInPlace node_modules/.bin/vite --replace "/usr/bin/env node" "${nodejs-slim_latest}/bin/node"
          '';
          buildPhase = "bun run build";
          installPhase = ''
            mkdir -p $out/bin
            cp -R ./build/* $out
            makeBinaryWrapper ${getExe http-server} $out/bin/${name} --add-flags "$out"
          '';
          # TODO why doesn't this work?!
          meta.mainProgram = name;
        };
      };
    };
  };
}
