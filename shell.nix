let
  pkgs = import ./nixpkgs {};
in pkgs.mkShell {
  nativeBuildInputs = with pkgs; [ colmena nix rpiboot ];
  shellHook = ''
    alias build="colmena build"
    alias deploy="colmena apply"
  '';
}
