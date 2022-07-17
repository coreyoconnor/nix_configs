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

  agh = { name, nodes, ... }: {
    imports = [ ./computers/agh ];

    config = {
      networking.hostName = "agh";
    };
  };

  grr = { name, nodes, ... }: {
    imports = [ ./computers/grr ];

    config = {
      networking.hostName = "grr";
    };
  };

  thrash = { name, nodes, ... }: {
    imports = [ ./computers/thrash ];

    config = {
      networking.hostName = "thrash";
    };
  };
}
