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
    networking.hostName = "deny";
    system.stateVersion = "23.05";

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
