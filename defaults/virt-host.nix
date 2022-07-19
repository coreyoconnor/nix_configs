{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.virt-host;

  baseConfig = {
    boot = { kernelModules = [ "virtio" ]; };

    networking = {
      firewall = {
        allowedTCPPorts = [ 16509 ];
        checkReversePath = false;
      };
    };

    virtualisation.podman.enable = true;
  };

  libvirtHost = {
    virtualisation.libvirtd = {
      enable = true;
      qemu.verbatimConfig = ''
        security_driver = "none"
      '';
    };

    environment.shellInit = ''
      export LIBVIRT_DEFAULT_URI=qemu:///system
    '';

    # duplicated here for explicitness
    environment.systemPackages = with pkgs; [
      libvirt
      qemu
    ];

    services.nfs.server.enable = true;

    networking.firewall.extraCommands = ''
      ip46tables -A INPUT -i virbr+ -j ACCEPT
      ip46tables -A OUTPUT -o virbr+ -j ACCEPT
    '';
  };
  shareInit = {
    system.activationScripts.libvirtShareDir = ''
      mkdir -p ${cfg.share-dir}
      chown root:libvirtd ${cfg.share-dir}
      chmod 770 ${cfg.share-dir}
    '';
  };
in {
  imports = [];

  options = {
    virt-host = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };

      share-dir = mkOption {
        type = types.str;
        default = "/var/lib/libvirt/images";
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [ baseConfig libvirtHost shareInit ]);
}
