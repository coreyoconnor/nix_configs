{config, pkgs, ...}:

{
  boot.kernelModules = [ "virtio" ];
  environment.systemPackages =
  [
      pkgs.kvm
  ];
}

