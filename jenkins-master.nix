{config, pkgs, ...}:
with pkgs.lib;
{
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
                 pkgs.curl ];
    extraGroups = [ "vboxusers" ];
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

  networking =
  {
    extraHosts = ''
      50.18.248.193 private
      50.18.248.193 data
      50.18.248.193 blog
    '';
  };
}
