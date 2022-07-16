{
  meta = {
    nixpkgs = ./nixpkgs;
  };

  defaults = { pkgs, ... }: {
    imports = [ ./defaults ];
  };

  thrash = { name, nodes, ... }: {
    imports = [ ./computers/thrash ];

    config = {
      networking.hostName = "thrash";
    };
  };
}
