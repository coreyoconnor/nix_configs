{config, pkgs, ...} :

{
  config =
  {
    environment.systemPackages = with pkgs; [
      metals
      sbt
      scala
      ammonite
    ];
  };
}
