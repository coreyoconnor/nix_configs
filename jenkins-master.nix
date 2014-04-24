{config, pkgs, ...}:
with pkgs.lib;
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
    wantedBy = [ "multi-user.target" ];
    requires = [ "jenkins.service" "network-online.target" ];
    path = [ pkgs.openssh ];
    script = ''
      ssh -R 8081:localhost:8080 -N private
    '';
    serviceConfig = {
      User = "jenkins";
      Restart = "always";
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
