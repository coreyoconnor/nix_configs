{config, pkgs, ...}:
with pkgs.lib;
{
  services.jenkins.enable = true;

  services.openssh =
  {
    knownHosts =
    [
      {
        hostNames = [ "github.com" ];
        publicKeyFile = ./github.com.pub;
      }
      {
        hostNames = [ "private" ];
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
