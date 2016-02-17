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
    '';
  };
}
