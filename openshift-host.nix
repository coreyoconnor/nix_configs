{config, pkgs, lib, ...}:
with lib;
let
  cfg = config.openshift-host;
  baseConfig =
  {
    networking =
    {
      firewall =
      {
        allowedTCPPorts = [ 53 80 443 4789 8053 8443 10250 ];
        allowedUDPPorts = [ 53 4789 8053 8443 10250 ];
        checkReversePath = false;
      };
    };

    services.haveged.enable = true;
    environment.systemPackages = [ pkgs.openshift pkgs.docker ];
  };
  openshiftHost =
  {
    virtualisation.docker =
    {
      enable = true;
      # extraOptions = "--insecure-registry 172.30.0.0/16";
    };

    # services.kubernetes =
    # {
    #   roles = ["master" "node"];
    # };

    services.dnsmasq =
    {
      resolveLocalQueries = true;
      servers = [
        "/.30.172.in-addr.arpa/192.168.1.2#8053"
        "/.cluster.local/192.168.1.2#8053"
        "1.1.1.1"
        "2606:4700:4700::1111"
        "8.8.8.8"
        "2001:4860:4860::8888"
      ];
      extraConfig = ''
        no-resolv
        domain-needed
        bogus-priv
        cache-size=1000
        address=/.agh.dev/192.168.1.2
      '';
    };
  };
in {
  options =
  {
    openshift-host =
    {
      enable = mkOption
      {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [baseConfig openshiftHost]);
}
