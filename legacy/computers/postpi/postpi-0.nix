{ config, pkgs, lib, ... }: {
  imports = [
    <nixpkgs/nixos/modules/installer/sd-card/sd-image-aarch64-new-kernel-installer.nix>
    ../../networks/home.nix
  ];

  config = {
    environment.systemPackages = with pkgs; [
      screen
      vim
    ];

    hardware.enableRedistributableFirmware = true;

    networking = {
      hostName = "postpi-0";
    };

    security.sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };

    services.openssh.enable = true;
  };
}
