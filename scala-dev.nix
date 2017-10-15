{config, pkgs, ...} :

{
  config =
  {
    environment.systemPackages =
      [ pkgs.scala
        pkgs.ammonite
      ];
  };
}
