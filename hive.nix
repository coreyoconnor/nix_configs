let
  postpiCount = 7;
  postpiConfig = nodeName: {
    imports = [ ./computers/postpi ];

    config = {
      networking.hostName = nodeName;
    };
  };
  postpiNodeNames = map (n: "postpi-" + (toString n))
                        (builtins.genList (n: n + 1) postpiCount);
  allPostpiConfigs = builtins.listToAttrs (
    map (name:
      {
        inherit name;
        value = postpiConfig name;
      }
    ) postpiNodeNames
  );
in allPostpiConfigs // {
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
