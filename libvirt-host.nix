{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.libvirt-host;
  baseConfig = {
    boot = { kernelModules = [ "virtio" ]; };

    networking = { firewall = { allowedTCPPorts = [ 16509 ]; checkReversePath = false; }; };

    services.haveged = {
      enable = true;
      refill_threshold = 2048;
    };
  };
  libvirtHost = {
    virtualisation.virtualbox.host.enable = false;
    virtualisation.libvirtd = {
      enable = true;
      extraConfig = ''
        listen_tls = 0
        listen_tcp = 1
        auth_tcp="none"
        tcp_port = "16509"
      '';
      extraOptions = [ "--listen" ];
      qemuVerbatimConfig = ''
        security_driver = "none"
      '';
    };

    environment.shellInit = ''
      export LIBVIRT_DEFAULT_URI=qemu:///system
    '';

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
      mkdir -p ${cfg.share-dir}
      chown root:libvirtd ${cfg.share-dir}
      chmod 770 ${cfg.share-dir}
    '';
  };
in {
  imports = [ ./vm-host/vfio.nix ];

  options = {
    libvirt-host = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };

      share-dir = mkOption {
        type = types.string;
        default = "/var/lib/libvirt/images";
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [ baseConfig libvirtHost shareInit ]);
}
