{
  meta = {
    nixpkgs = ./nixpkgs;
  };

  defaults = { pkgs, ... }: {
    imports = [ ./defaults ./modules ];
  };

  thrash = { name, nodes, ... }: {
    imports = [ ./computers/thrash ];

    config = {
      networking.hostName = "thrash";
    };
  };
}
