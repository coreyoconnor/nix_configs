{
  pkgs
}: name: src: {subcommand ? "", ...} @ args:
pkgs.replaceVarsWith {
  inherit name src;
  isExecutable = true;
  dir = "bin";
  replacements =
    args
    // {
      fishShell = "${pkgs.fish}/bin/fish";
      inherit nixDevInputArgs;
    };
}

