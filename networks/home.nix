{config, pkgs, ...}:
{
  networking = 
  {
    extraHosts = ''
      192.168.1.95 ufo
      192.168.1.145 agh
    '';
  };
}
