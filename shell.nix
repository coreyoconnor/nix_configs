let
  pkgs = import ./nixpkgs {};
in pkgs.mkShell {
  #nativeBuildInputs = with pkgs; [ colmena nixVersions.nix_2_3 ];
  nativeBuildInputs = with pkgs; [ colmena nixVersions.nix_2_3 ];
}
