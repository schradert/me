{
  perSystem = {
    inputs',
    nix,
    pkgs,
    self',
    ...
  }: let
    inherit (inputs'.nix2container.packages.nix2container) buildImage buildLayer;
    inherit (nix) getExe;
    inherit (pkgs) arion bun git openssh rsync writeShellScriptBin;
    inherit (self'.packages) me;
    ssh = getExe openssh;
    domain = "trdos.me";
    inherit (me) name;
    tag = me.version;
  in {
    canivete.arion.modules.main = {self'', ...}: {services.me.image.command = [(getExe self''.packages.me)];};
    packages = {
      inherit arion;
      container = buildImage {
        inherit name tag;
        config.entrypoint = [(getExe me)];
        layers = [(buildLayer {deps = [bun];})];
      };
      # TODO avoid hardcoding relative path of source code (i.e. $tmp/me)
      # TODO how can I get around generating an archive?!
      # NOTE copyToRegistry and copyToPodman don't work (unauthorized, separate registry)
      publish = writeShellScriptBin "publish" ''
        tmp="$(${ssh} ${domain} mktemp -d)"
        trap '${ssh} ${domain} rm -rf "$tmpDir"' EXIT
        ${getExe rsync} -avz "$(${getExe git} rev-parse --show-toplevel)" "${domain}:$tmp"
        ${ssh} ${domain} nix run "$tmp/me#container.copyTo" -- "docker-archive:$tmp/${name}.tar:${name}:${tag}"
        ${ssh} ${domain} sudo k3s ctr images import "$tmp/${name}.tar"
      '';
      publish-ifd = writeShellScriptBin "publish-ifd" ''
        drv="$(nix path-info --derivation .#packages.x86_64-linux.container.copyToRegistry)"
        nix copy --derivation --to ssh-ng://${domain} "$drv"
        closure="$(${ssh} ${domain} nix-store --verbose --realise "$drv")"
        ${ssh} ${domain} "$closure/bin/copy-to-registry"
      '';
    };
  };
}
