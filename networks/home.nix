{ config, pkgs, ... }: {
  imports = [
    ./known-hosts.nix
    ../users/admin.nix
    ../users/bretto.nix
    ../users/coconnor.nix
    ../users/jenkins.nix
    ../users/media.nix
    ../users/nix.nix
  ];

  config = {
    networking = {
      extraHosts = ''
        192.168.86.2 agh
        192.168.86.3 glowness
        192.168.86.5 thrash
        192.168.86.7 grr
        192.168.86.17 grr-alt
        192.168.86.189 atomicpi
      '';
    };

    security.pki.certificateFiles = [ ./agh-0.crt ];
  };
}
