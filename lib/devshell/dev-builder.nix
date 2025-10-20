{
  pkgs,
  devFlakes
}:
let
  devArgs = builtins.concatMap (
    inputName: [
      "--override-input"
      inputName
      "path:./dev/${inputName}"
    ]
  ) (builtins.attrNames devFlakes);
  nixDevInputArgs = pkgs.lib.concatStringsSep " " devArgs;
in name: src: {
  subcommand ? "",
  ...
}@args:
pkgs.replaceVarsWith {
  inherit name src;
  isExecutable = true;
  dir = "bin";
  replacements = args // {
    fishShell = "${pkgs.fish}/bin/fish";
    inherit nixDevInputArgs;
  };
}

