{config, pkgs, ...}:
{
  boot.blacklistedKernelModules = [ "nouveau" ];
  boot.kernelParams = [ "nomodeset" "video=vesa:off" "vga=normal" ];
  boot.vesa = false;

  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;
  services.xserver.videoDrivers = [ "nvidia" "vesa" ];
}
