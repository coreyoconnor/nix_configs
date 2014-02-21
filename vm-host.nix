{config, pkgs, ...}:

{
  imports = [ <nixos/modules/programs/virtualbox.nix> ];

  nixpkgs.config.virtualbox.enableExtensionPack = true;

  boot.kernelModules = [ "virtio" ];
  environment.systemPackages =
  [
      pkgs.kvm
  ];
}

