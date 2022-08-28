{ config, pkgs, lib, ... }: {
  imports = [
    <nixpkgs/nixos/modules/installer/sd-card/sd-image-aarch64-new-kernel.nix>
    ../../network/home
    ../../domains/primary
  ];

  config = {
    environment.systemPackages = with pkgs; [
      screen
      vim
    ];

    hardware.enableRedistributableFirmware = true;

    security.sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };

    services.openssh.enable = true;
  };
}
