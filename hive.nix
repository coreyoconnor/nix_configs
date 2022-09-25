let
  postpiCount = 7;
  postpiConfig = nodeName: {
    imports = [ ./computers/postpi ];

    config = {
      networking.hostName = nodeName;
      system.stateVersion = "22.05";
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

    # defaults: always set or the option defaults to enabled
    # modules: enable always defaults to false
    imports = [ ./defaults ./modules ];
  };

  agh = { name, nodes, ... }: {
    imports = [ ./computers/agh ];

    config = {
      networking.hostName = "agh";
      system.stateVersion = "22.05";
    };
  };

  grr = { name, nodes, ... }: {
    imports = [ ./computers/grr ];

    config = {
      networking.hostName = "grr";
      system.stateVersion = "22.05";
    };
  };

  thrash = { name, nodes, ... }: {
    imports = [ ./computers/thrash ];

    config = {
      networking.hostName = "thrash";
      system.stateVersion = "22.05";
    };
  };
}
