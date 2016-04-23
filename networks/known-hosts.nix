{config, pkgs, ...}:
{
  config =
  {
    services.openssh =
    {
      knownHosts =
      [
        {
          hostNames = [ "github.com" ];
          publicKeyFile = ./known-hosts/github.com.pub;
        }
        {
          hostNames = [ "50.18.248.193" "private" "coreyoconnor.com" ];
          publicKeyFile = ./known-hosts/coreyoconnor.com.pub;
        }
      ];
    };
  };
}
