{config, pkgs, ...}:
{
  networking = 
  {
    hostName = "toast"; # must be unique
    extraHosts = ''
      192.168.1.95 ufo
      192.168.1.142 toast
      192.168.1.157 agh
    '';
  };
}
