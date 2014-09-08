{config, pkgs, ...}:
{
  networking = 
  {
    extraHosts = ''
      192.168.1.2 agh
      192.168.1.3 waffle
      192.168.1.4 ufo
    '';
  };
}
