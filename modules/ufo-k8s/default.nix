{
  config,
  pkgs,
  lib,
  nix-kube-modules,
  ...
}:
with lib; let
  cfg = config.ufo-k8s;
in {
  imports = [
    nix-kube-modules.nixosModules.helm
  ];

  options = {
    ufo-k8s = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.enable {
    environment = {
      etc = {
        "rancher/k3s/registries.yaml".source = pkgs.writeText "rancher-k3s-registeries.yaml" ''
          mirrors:
            "ufo.local:5000":
              endpoint:
                - "http://ufo.local:5000"
        '';
      };

      systemPackages = with pkgs; [k3s];
    };
    networking.firewall.allowedTCPPorts = [443 6443 10250];
    virtualisation.containers.registries.insecure = ["ufo.local:5000"];
    services.dockerRegistry = {
      enable = true;
      enableDelete = true;
      enableGarbageCollect = true;
      listenAddress = "192.168.88.4";
      openFirewall = true;
    };
    services.k3s = {
      enable = true;
      role = "server";
    };
    system.k3s.helm = {
      enable = false;
      charts = {
        #hub = {
        #  namespace = "hub";
        #  repo = "jupyterhub";
        #  version = "";
        #  values = import ./jupyterhub-config.nix;
        #};
      };
    };
  };
}
