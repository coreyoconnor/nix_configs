{config, pkgs, ...}:
with pkgs.lib;
{
  users.extraUsers =
  { 
    admin = 
    { 
      createHome = true;
      uid = 1000;
      group = "users";
      extraGroups = [ "wheel" "vboxusers" ];
      home = "/home/admin";
      shell = pkgs.bashInteractive + "/bin/bash";
    };
  };
}
