self: super: {
  nix-dev = self.writeShellScriptBin "nix-dev" ''
    exec nix-shell . -A env "$@"
  '';
}
