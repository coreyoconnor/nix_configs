{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  imports = [
    ../../hardware/lenovo-thinkpad-x1-7th-gen.nix
    ./filesystems.nix
    ./memory.nix
    ../../domains/primary
  ];

  config = {
    system.stateVersion = "23.05";

    networking = {
      extraHosts = ''
        192.168.88.4 ufo
        192.168.88.18 glowness
        192.168.88.23 deny
      '';
      hostName = "deny";
    };

    boot = {
      initrd = {
        preLVMCommands = ''
          echo "██╗   ██╗███████╗ ██████╗               ██████╗ ███████╗███╗   ██╗██╗   ██╗"
          echo "██║   ██║██╔════╝██╔═══██╗              ██╔══██╗██╔════╝████╗  ██║╚██╗ ██╔╝"
          echo "██║   ██║█████╗  ██║   ██║    █████╗    ██║  ██║█████╗  ██╔██╗ ██║ ╚████╔╝ "
          echo "██║   ██║██╔══╝  ██║   ██║    ╚════╝    ██║  ██║██╔══╝  ██║╚██╗██║  ╚██╔╝  "
          echo "╚██████╔╝██║     ╚██████╔╝              ██████╔╝███████╗██║ ╚████║   ██║   "
          echo " ╚═════╝ ╚═╝      ╚═════╝               ╚═════╝ ╚══════╝╚═╝  ╚═══╝   ╚═╝   "
        '';
      };
    };

    desktop.enable = true;
    developer-base.enable = true;
    networking.firewall.enable = true;
    networking.enableIPv6 = true;

    powerManagement.cpuFreqGovernor = "powersave";

    programs.captive-browser = {
      enable = true;
      interface = "wlp0s20f3";
    };

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };

    services.foreign-binary-emulation.enable = true;
    services.kbfs.enable = true;

    virt-host.enable = true;

    virtualisation = {
      containers.enable = true;
      waydroid.enable = true;
      lxd.enable = true;
    };
  };
}
