{config, pkgs, ...}:
{
  networking =
  {
    extraHosts = ''
      192.168.1.2 agh
      192.168.1.3 waffle
      192.168.1.4 ufo
      192.168.1.5 thrash
      192.168.1.6 alter

      50.18.248.193 private
      50.18.248.193 data
      50.18.248.193 blog
    '';
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
}
