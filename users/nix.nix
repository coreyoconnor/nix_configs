{config, pkgs, ...}:
with pkgs.lib;
{
  users.extraUsers =
  {
    nix =
    {
      isSystemUser = true;
      openssh.authorizedKeys.keyFiles = [./ssh/nix.pub];
    };
  };
}
