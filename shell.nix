let
  pkgs = import ./nixpkgs {};
in pkgs.mkShell {
  nativeBuildInputs = with pkgs; [ colmena emacs nixVersions.nix_2_3 ];
}
