{config, pkgs, ...}:

{
  imports = [ <nixos/modules/programs/virtualbox.nix> ];

  boot.kernelModules = [ "virtio" ];
  environment.systemPackages =
  [
      pkgs.kvm
  ];
}

