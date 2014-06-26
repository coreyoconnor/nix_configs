{config, pkgs, ...}:
{
  require =
  [
    ./config-at-bootstrap.nix
    ../../editorIsVim.nix
    ../../haskell-dev.nix
    ../../i18n.nix
    ../../jenkins-master.nix
    ../../scala-dev.nix
    ../../standard-env.nix
    ../../standard-packages.nix
    ../../standard-nixpath.nix
    ../../standard-services.nix
    ../../udev.nix
    ../../users/coconnor.nix
    ../../users/admin.nix
  ];

  services.xserver = 
  {
    enable = true;
    autorun = true;
  };
}
