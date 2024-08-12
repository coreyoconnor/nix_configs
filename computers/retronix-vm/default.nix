{
  config,
  lib,
  pkgs,
  nixpkgs,
  retronix,
  ...
}:
with lib; {
  imports = [
    ../../domains/primary
    retronix.nixosModules.default
    (nixpkgs + "/nixos/modules/virtualisation/qemu-vm.nix")
  ];

  config = {
    networking.hostName = "retronix-vm";
    system.stateVersion = "24.05";

    users.users.media.password = "media";

    retronix = {
      enable = true;
      # steamLauncher = true;
      nick = "UFO";
      user = "media";
    };
  };
}
