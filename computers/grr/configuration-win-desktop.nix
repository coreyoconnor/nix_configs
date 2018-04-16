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
      enable = false;
    };
  };

  services.xserver.enable = false;
}
