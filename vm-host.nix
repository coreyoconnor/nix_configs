{config, pkgs, ...}:

{
  nixpkgs.config.virtualbox.enableExtensionPack = true;

  boot.kernelModules = [ "virtio" ];
  # The qemu-kvm wrapper NixOS provides will not enable KVM if the kernel modules have not been
  # loaded (The /dev/kvm device does not exist) Yet we still add pkgs.kvm for compatibility with
  # software that assumes KVM exists.  This actually works out fine and for my usage (testing) the
  # performance is perfectly acceptable.
  boot.blacklistedKernelModules = [ "kvm" "kvm_amd" "kvm_intel" ];

  services.virtualboxHost.enable = true;

  environment.systemPackages =
  [
      pkgs.kvm
  ];
}

