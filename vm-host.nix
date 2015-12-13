{config, pkgs, lib, ...}:
with lib;
let
  cfg = config.vmhost;
  commonConfig =
  {
    boot.kernelModules = [ "virtio" ];
    networking.firewall.allowedTCPPorts = [ 3389 3390 3391 3392 ];
    virtualisation.libvirtd.enable = true;
  };
  vboxHost = mkIf (cfg.type == "virtualbox")
  {
    virtualisation.libvirtd.enableKVM = false;
    virtualisation.virtualbox.host.enable = true;

    nixpkgs.config.virtualbox.enableExtensionPack = true;
    # The qemu-kvm wrapper NixOS provides will not enable KVM if the kernel modules have not been
    # loaded (The /dev/kvm device does not exist) Yet we still add qemu for compatibility with
    # software that assumes qemu exists.  This actually works out fine and for my usage (testing) the
    # performance is perfectly acceptable.
    boot.blacklistedKernelModules = [ "kvm" "kvm_amd" "kvm_intel" ];

    environment.systemPackages = [ pkgs.qemu ];
  };
  kvmHost = mkIf (cfg.type == "libvirtd")
  {
    virtualisation.libvirtd.enableKVM = true;

    # duplicated here for explicitness
    environment.systemPackages = [ pkgs.qemu_kvm ];
  };
in {
  options = {
    vmhost.type = mkOption {
      type = types.string;
      default = "virtualbox";
      description = ''
        Virtualization platform to use.
      '';
    };
  };

  config = mkMerge [commonConfig vboxHost kvmHost];
}
