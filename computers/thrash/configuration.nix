{ config, pkgs, ... }:
let
  localIp = "192.168.1.5";
in {
  imports = [
    ./config-at-bootstrap.nix
    ../../base.nix
    ../../dev.nix
    ../../editorIsVim.nix
    ../../i18n.nix
    ../../media-presenter.nix
    ../../networks/home.nix
    ../../standard-env.nix
    ../../standard-packages.nix
    ../../standard-services.nix
    ../../tobert-config.nix
    ../../udev.nix
  ];

  config = {
  media-presenter.enable = true;

  services.openssh = {
    extraConfig = ''
      UseDNS no
    '';
    forwardX11 = true;
  };
  networking = {
    hostName = "thrash";
    interfaces.enp2s0f0 = {
        ipv4.addresses = [{
          address = localIp;
          prefixLength = 24;
        }];
        ipv6 = {
          addresses = [{
            address = "2601:602:9700:f0fc::5";
            prefixLength = 64;
          }];
        };
    };
    defaultGateway = "192.168.1.1";
    nameservers = [ "192.168.1.2" "1.1.1.1" ];
  };
  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio = {
    # enable = true;
    support32Bit = true;
  };
  sound = {
    enable = true;
    extraConfig = ''
      pcm.!default {
        type hw
        card 0
        device 8
      }
      ctl.!default {
        type hw
        card 0
        device 8
      }
    '';
  };
  fileSystems = {
    "/mnt/storage/media" = {
      fsType = "cifs";
      device = "//agh/media";
      options = [
        "guest"
        "uid=media"
        "gid=users"
        "rw"
        "setuids"
        "file_mode=0664"
        "dir_mode=0775"
        "vers=3.0"
        "nofail"
        "x-systemd.automount"
        "noauto"
      ];
    };
  };

  services.xserver = {
    videoDrivers = [ "i915" "vesa" "modesetting" ];
  };
};
}
