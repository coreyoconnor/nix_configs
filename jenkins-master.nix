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
                 pkgs.libvirt # required by nixops
                 pkgs.openssh
                 pkgs.nix
                 pkgs.gzip
                 pkgs.curl
                 pkgs.xorg.xorgserver
                 pkgs.qemu_kvm # required by nixops
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

  systemd.services.private-reverse-tunnel =
  {
    description = "Private Reverse Tunnel";
    wantedBy = ["multi-user.target"];
    wants = ["network-online.target"];
    path = [ pkgs.openssh pkgs.gawk pkgs.iproute ];
    script = ''
      while [ -z "$(ip addr show enp1s0 | grep inet | awk '{print $2}' | head -1)" ]
      do
        sleep 5
      done

      ssh -NTC -o ServerAliveInterval=60 -o ExitOnForwardFailure=yes \
          -R 2222:localhost:22 private
    '';
    serviceConfig = {
      User = "jenkins";
      Restart = "always";
      RestartSec = 3;
    };
  };

  networking =
  {
    firewall.allowedTCPPorts = [ 8080 53251 ];
  };
}
