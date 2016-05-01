{config, pkgs, ...}:
with pkgs.lib;
{
  users.extraUsers =
  {
    boconnor =
    {
      uid = 1101;
      createHome = true;
      group = "users";
      home = "/home/boconnor";
      shell = pkgs.bashInteractive + "/bin/bash";
      openssh.authorizedKeys.keyFiles = [./ssh/brett.pub];
    };
  };
}
