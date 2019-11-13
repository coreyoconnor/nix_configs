{config, pkgs, lib, ...}:
with lib;
let
  cfg = config.libvirt-host;
  baseConfig = {
    boot = {
      kernelModules = [ "virtio" ];
    };

    networking = {
      firewall = {
        checkReversePath = false;
      };
    };

    services.haveged.enable = true;
  };
  libvirtHost = {
    virtualisation.virtualbox.host.enable = false;
    virtualisation.libvirtd.enable = true;

    # duplicated here for explicitness
    environment.systemPackages = with pkgs; [
      docker-machine-kvm
      libvirt
      qemu
      vagrant
    ];
    services.nfs.server.enable = true;

    networking.firewall.extraCommands = ''
      ip46tables -A INPUT -i virbr+ -j ACCEPT
      ip46tables -A OUTPUT -o virbr+ -j ACCEPT
    '';
  };
  shareInit = {
    system.activationScripts.libvirtShareDir = ''
      mkdir -p ${cfg.shareDir}
      chown root:libvirtd ${cfg.shareDir}
      chmod 770 ${cfg.shareDir}
    '';
  };
in {
  imports = [
    ./vm-host/vfio.nix
  ];

  options = {
    libvirt-host = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };

      shareDir = mkOption {
        type = types.string;
        default = "/var/lib/libvirt/images";
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [baseConfig libvirtHost shareInit]);
}
