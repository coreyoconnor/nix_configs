nixpkgs: let
  postpiCount = 7;
  postpiConfig = nodeName: {
    imports = [./computers/postpi];

    config = {
      deployment.targetHost = nodeName + ".lan";

      networking.hostName = nodeName;

      nixpkgs.system = "aarch64-linux";

      system.stateVersion = "23.11";
    };
  };
  postpiNodeNames =
    map (n: "postpi-" + (toString n))
    (builtins.genList (n: n + 1) postpiCount);
  allPostpiConfigs = builtins.listToAttrs (
    map
    (
      name: {
        inherit name;
        value = postpiConfig name;
      }
    )
    postpiNodeNames
  );
in
  allPostpiConfigs
  // {
    meta = {
      inherit nixpkgs;
    };

    defaults = {pkgs, ...}: {
      # defaults: always set or the option defaults to enabled
      # modules: enable always defaults to false
      imports = [./defaults ./modules];

      config = {
        deployment = {
          targetUser = pkgs.lib.mkDefault (builtins.getEnv "USER");
        };
      };
    };

    agh = {
      name,
      nodes,
      ...
    }: {
      imports = [./computers/agh];

      config = {
        deployment = {
          allowLocalDeployment = true;
        };

        networking.hostName = "agh";
        system.stateVersion = "22.05";
      };
    };

    deny = {
      name,
      nodes,
      ...
    }: {
      imports = [./computers/deny];

      config = {
        deployment = {
          allowLocalDeployment = true;
        };

        networking.hostName = "deny";
        system.stateVersion = "23.05";
      };
    };

    glowness = {
      name,
      nodes,
      ...
    }: {
      imports = [./computers/glowness];

      config = {
        deployment = {
          allowLocalDeployment = true;
        };

        networking.hostName = "glowness";
        system.stateVersion = "22.11";
      };
    };

    grr = {
      name,
      nodes,
      ...
    }: {
      imports = [./computers/grr];

      config = {
        deployment = {
          allowLocalDeployment = true;
        };

        networking.hostName = "grr";
        system.stateVersion = "22.05";
      };
    };

    installer = {
      name,
      nodes,
      ...
    }: {
      imports = [./installer];

      config = {
        deployment = {
          allowLocalDeployment = false;
          targetHost = null;
        };

        networking.hostName = "nixos-installer";
        system.stateVersion = "23.05";
      };
    };

    thrash = {
      name,
      nodes,
      ...
    }: {
      imports = [./computers/thrash];

      config = {
        networking.hostName = "thrash";
        system.stateVersion = "22.05";
      };
    };
  }
