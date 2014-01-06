{config, pkgs, ...}:
{
  boot.blacklistedKernelModules = [ "nouveau" ];
  boot.extraKernelParams = [ "nomodeset" "video=vesa:off" "vga=normal" ];
  boot.vesa = false;
}
