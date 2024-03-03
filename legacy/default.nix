let
  system = builtins.currentSystem;
  eval = import ./nixpkgs/nixos/lib/eval-config.nix {
    inherit system;
    modules = [./computers/thrash/configuration.nix];
  };
  inherit (eval) pkgs config options;
  inherit (pkgs) lib;
  image = import ./nixpkgs/nixos/lib/make-disk-image.nix {
    inherit pkgs lib config;
    diskSize = "16000";
    partitionTableType = "efi";
    format = "qcow2-compressed";
  };
in {
  inherit image pkgs;
}
