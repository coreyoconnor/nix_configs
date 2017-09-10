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
          hostNames = [ "private" ];
          publicKeyFile = ./known-hosts/private.pub;
        }
        {
          hostNames = [ "public" "coreyoconnor.com" ];
          publicKeyFile = ./known-hosts/coreyoconnor.com.pub;
        }
      ];
    };
  };
}
