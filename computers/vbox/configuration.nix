{config, pkgs, ...}:

{
  require =
  [
    <nixos/modules/installer/scan/not-detected.nix>
    ../../editorIsVim.nix
    ../../users/coconnor.nix
    ../../filesystem.nix
    ../../i18n.nix
    ../../haskell-dev.nix
  ];

  nix.maxJobs = 2;

  boot.loader.grub =
  {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  boot.initrd.availableKernelModules = [ "ata_piix" "ohci_hcd" "ehci_hcd" ];

  environment.systemPackages =
  [
    pkgs.stdenv
    pkgs.autoconf
    pkgs.automake
    pkgs.bashInteractive
    pkgs.glibcLocales
    pkgs.screen
    pkgs.utillinuxCurses
    pkgs.gitSVN
    pkgs.acpi
    pkgs.gcc
    pkgs.gettext
    pkgs.glib
    pkgs.gnumake
    pkgs.nginx
    pkgs.qemu
    pkgs.kvm
  ];

  networking =
  {
    hostName = "nixos-vbox";
  };

  security.sudo.enable = true;
  security.sudo.configFile = ''
    Defaults:root,%wheel env_keep+=LOCALE_ARCHIVE
    Defaults:root,%wheel env_keep+=NIX_PATH
    Defaults:root,%wheel env_keep+=TERMINFO_DIRS

    root        ALL=(ALL) SETENV: ALL
    %wheel      ALL=(ALL) NOPASSWD: SETENV: ALL
'';

  services.dbus.enable = true;
  services.udisks2.enable = true;
  services.upower.enable = true;
  services.acpid.enable = true;
  # Add the NixOS Manual on virtual console 8
  services.nixosManual.showManual = true;
  services.openssh.enable = true;
  # TODO: I only want to disable X11 forwarding for ssh client
  services.openssh.forwardX11 = false;
  services.virtualbox.enable = true;
}
