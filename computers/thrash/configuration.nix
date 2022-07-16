{ config, pkgs, ... }:
let
  localIp = "192.168.86.5";
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
    system.stateVersion = "22.05";

    media-presenter.enable = true;
    retronix.nick = "UFO";

    services.openssh = {
      extraConfig = ''
        UseDNS no
      '';
      forwardX11 = true;
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
        amdvlk
      ];
    };

    hardware.pulseaudio = {
      enable = false;
      systemWide = true;
    };

    sound = {
      enable = true;
      extraConfig = ''
        pcm.!default {
          type hw
          card 0
          device 3
        }
        ctl.!default {
          type hw
          card 0
          device 3
        }
      '';
    };


    services.xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" "modesetting" "vesa" ];
    };

    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
    };

    programs.gamemode.enable = true;
  };
}
