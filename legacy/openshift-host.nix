{ config, pkgs, lib, ... }:
with lib;
# https://servicesblog.redhat.com/2019/07/11/installing-openshift-4-1-using-libvirt-and-kvm/
let
  cfg = config.openshift-host;
in {
  options = {
    openshift-host = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.enable {
    networking = {
      firewall = {
        allowedTCPPorts = [ 53 8443 ];
        allowedUDPPorts = [ 53 8443 ];
        checkReversePath = false;
      };
    };

    services.haveged.enable = true;
    services.dnsmasq.enable = false;
    environment.systemPackages = [ pkgs.openshift pkgs.docker pkgs.zfs ];

    virtualisation.docker = {
      enable = true;
      extraOptions = "--insecure-registry 172.30.0.0/16";
    };

    #services.dnsmasq = {
    #  resolveLocalQueries = true;
    #  servers = [
    #    "/.30.172.in-addr.arpa/192.168.1.2#8053"
    #    "/.cluster.local/192.168.1.2#8053"
    #    "1.1.1.1"
    #    "2606:4700:4700::1111"
    #    "8.8.8.8"
    #    "2001:4860:4860::8888"
    #  ];
    #  extraConfig = ''
    #    no-resolv
    #    domain-needed
    #    bogus-priv
    #    cache-size=1000
    #    address=/.agh.dev/192.168.1.2
    #    conf-file=${pkgs.dnsmasq}/share/dnsmasq/trust-anchors.conf
    #    dnssec
    #  '';
    #};
  };
}
