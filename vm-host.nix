{config, pkgs, lib, ...}:
with lib;
let
  cfg = config.vmhost;
  commonConfig =
  {
    boot =
    {
      kernelModules = [ "virtio" ];
    };

    networking =
    {
      firewall =
      {
        allowedTCPPorts = [ 53 8053 8443 3389 3390 3391 3392 ];
        checkReversePath = false;
      };
      search = [ "cluster.local" ];
    };
    virtualisation.docker =
    {
      enable = true;
      extraOptions = "--insecure-registry 172.30.0.0/16 --exec-opt native.cgroupdriver=systemd";
    };
    services.dnsmasq =
    {
      enable = true;
      resolveLocalQueries = true;
      servers = [ "1.1.1.1" "8.8.8.8" "/in-addr.arpa/127.0.0.1#8053" "/local/127.0.0.1#8053" ];
      extraConfig = ''
        no-resolv
        domain-needed
        bogus-priv
      '';
    };
    services.haveged.enable = true;
    environment.systemPackages = [ pkgs.openshift ];
  };
  vboxHost = mkIf (cfg.type == "virtualbox")
  {
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
    virtualisation.virtualbox.host.enable = false;
    users.extraGroups.libvirtd.gid = config.ids.gids.libvirtd;
    # virtualisation.libvirtd.enable = true;

    # duplicated here for explicitness
    environment.systemPackages = [ pkgs.libvirt pkgs.qemu ];
  };
  shareInit =
  {
    system.activationScripts.libvirtShareDir = ''
      mkdir -p ${cfg.shareDir}
      chown root:libvirtd ${cfg.shareDir}
      chmod 770 ${cfg.shareDir}
    '';
  };
in {
  imports =
  [
    ./vm-host/vfio.nix
  ];

  options =
  {
    vmhost =
    {
      type = mkOption
      {
        type = types.string;
        default = "virtualbox";
        description = ''
          Virtualization platform to use.
        '';
      };

      shareDir = mkOption
      {
        type = types.string;
        default = "/var/lib/libvirt/images";
      };
    };
  };

  config = mkMerge [commonConfig vboxHost kvmHost shareInit];
}
