{ config, pkgs, ... }:

{
  require =
  [
    ./common-configuration.nix
    ./windows-desktop-vm.nix
  ];

  hardware =
  {
    opengl =
    {
      enable = true;
      driSupport32Bit = true;
      useGLVND = true;
    };
  };

  services.xserver.enable = false;
}
