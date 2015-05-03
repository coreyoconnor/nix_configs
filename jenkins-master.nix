{config, pkgs, lib, ...}:
with lib;
{
  require = [ ./jenkins-node.nix ];

  services.jenkins =
  {
    enable = true;
    packages = [ pkgs.bash
                 pkgs.stdenv
                 pkgs.git
                 pkgs.jdk
                 pkgs.openssh
                 pkgs.nix
                 pkgs.nixops
                 pkgs.gzip
                 config.boot.kernelPackages.virtualbox 
                 pkgs.curl
                 pkgs.xorg.xorgserver ];
  };

  services.openssh =
  {
    knownHosts =
    [
      {
        hostNames = [ "github.com" ];
        publicKeyFile = ./github.com.pub;
      }
      {
        hostNames = [ "50.18.248.193" "private" ];
        publicKeyFile = ./private.pub;
      }
    ];
  };

  systemd.services.private-jenkins-notification =
  {
    description = "Notifications From Private To Jenkins On Commit";
    wantedBy = ["multi-user.target"];
    requires = ["jenkins.service"];
    wants = ["network-online.target"];
    path = [ pkgs.openssh pkgs.gawk pkgs.iproute ];
    script = ''
      while [ -z "$(ip addr show enp1s0 | grep inet | awk '{print $2}' | head -1)" ]
      do
        sleep 5
      done

      ssh -NTC -o ServerAliveInterval=60 -o ExitOnForwardFailure=yes \
          -R 8081:localhost:8080 private
    '';
    serviceConfig = {
      User = "jenkins";
      Restart = "always";
      RestartSec = 3;
    };
  };

  networking =
  {
    extraHosts = ''
      50.18.248.193 private
      50.18.248.193 data
      50.18.248.193 blog
    '';

    firewall.allowedTCPPorts = [ 8080 53251 ];
  };
}
