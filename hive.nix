{
  meta = {
    nixpkgs = ./nixpkgs;
  };

  defaults = { pkgs, ... }: {
    deployment = {
      targetUser = builtins.getEnv "USER";
    };

    imports = [ ./defaults ./modules ];
  };

  thrash = { name, nodes, ... }: {
    imports = [ ./computers/thrash ];

    config = {
      networking.hostName = "thrash";
    };
  };
}
