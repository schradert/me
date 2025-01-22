{
  perSystem = {nix, pkgs, self', ...}: let
    inherit (nix) getExe toList;
    inherit (pkgs) kapp writeShellScriptBin;
    inherit (self'.packages) container kubenix;
    domain = "trdos.me";
  in {
    packages.deploy = writeShellScriptBin "deploy" "${getExe kubenix} prod \"${getExe kapp} deploy -a me -f- -y\"";
    canivete.kubenix.clusters.prod = {
      deploy.fetchKubeconfig = "ssh ${domain} sudo k3s kubectl config view --raw | sed 's/127\.0\.0\.1/${domain}/'";
      modules.main = {helm, ...}: {
        kubernetes.helm.releases.me = {
          namespace = "office";
          chart = helm.fetch {
            repo = "https://bjw-s.github.io/helm-charts";
            chart = "app-template";
            version = "3.3.2";
            sha256 = "9Lx3jPGiLaE+joGy2GWxLzjWDu8wCa+4DrS9atf2zug=";
          };
          values.controllers.me.containers.me = {
            image.repository = "me";
            image.tag = container.imageTag;
            probes.liveness.enabled = true;
            probes.readiness.enabled = true;
            probes.startup.enabled = true;
          };
          values.service.me = {
            controller = "me";
            ports.http.port = 8080;
          };
          values.ingress.me = {
            annotations."external-dns.alpha.kubernetes.io/target" = "external.${domain}";
            className = "external";
            hosts = toList {
              host = "me.${domain}";
              paths = toList {
                path = "/";
                service.identifier = "me";
                service.port = "http";
              };
            };
          };
        };
      };
    };
  };
}
