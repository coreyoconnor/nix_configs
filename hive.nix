let
  postpiCount = 7;
  postpiConfig = nodeName: {
    imports = [ ./computers/postpi ];

    config = {
      deployment.targetHost = null;

      networking.hostName = nodeName;

      nixpkgs.system = "aarch64-linux";

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
    # defaults: always set or the option defaults to enabled
    # modules: enable always defaults to false
    imports = [ ./defaults ./modules ];

    config = {
      deployment = {
        targetUser = pkgs.lib.mkDefault (builtins.getEnv "USER");
      };
    };
  };

  agh = { name, nodes, ... }: {
    imports = [ ./computers/agh ];

    config = {
      deployment = {
        allowLocalDeployment = true;
      };

      networking.hostName = "agh";
      system.stateVersion = "22.05";
    };
  };

  glowness = { name, nodes, ... }: {
    imports = [ ./computers/glowness ];

    config = {
      deployment = {
        allowLocalDeployment = true;
        targetUser = "root";
      };

      networking.hostName = "glowness";
      system.stateVersion = "22.11";
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
