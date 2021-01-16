{ config, pkgs, ... }:
let
  localIp = "192.168.1.5";
in {
  imports = [
    ./hardware-configuration.nix
    ../../base.nix
    ../../editorIsVim.nix
    ../../media-presenter.nix
    ../../networks/home.nix
    ../../fonts.nix
  ];

  config = {

    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    media-presenter.enable = true;

    services.openssh = {
      extraConfig = ''
        UseDNS no
      '';
      forwardX11 = true;
    };

    networking = {
      hostName = "thrash";
      defaultGateway = "192.168.1.1";
      nameservers = [ "192.168.1.2" "1.1.1.1" ];
      interfaces = {
        enp2s0f0 = {
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
        enp2s0.useDHCP = true;
        wlp4s0.useDHCP = true;
      };
    };

    i18n.defaultLocale = "en_US.UTF-8";
    console = {
      font = "Lat2-Terminus16";
      keyMap = "us";
    };

    hardware.opengl = {
      enable = true;
      driSupport = true;
      extraPackages = with pkgs; [
        beignet
        vaapiVdpau
        libvdpau-va-gl
      ];
    };

    hardware.pulseaudio = {
      enable = false;
    };

    sound = {
      enable = true;
      /*
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
      */
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
      enable = true;
      videoDrivers = [ "amdgpu" "modesetting" "vesa" ];
    };

    virtualisation.docker = {
      enable = true;
      autoPrune.enable = true;
    };
  };
}
