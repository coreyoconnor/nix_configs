{ config, pkgs, lib, ... }:
with lib;
{
  options = { };

  config = {
    nixpkgs = import ./nixpkgs-config { inherit config pkgs lib; };
  };
}
