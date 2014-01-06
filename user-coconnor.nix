{config, pkgs, ...}:
with pkgs.lib;
{
  # make sure the required groups exist
  users.extraGroups =
  [
    { name = "vboxusers"; }
    { name = "transmission"; }
    { name = "plugdev"; }
  ];

  users.extraUsers =
  { 
    coconnor = 
    { 
      createHome = true;
      group = "users";
      extraGroups = [ "wheel" "vboxusers" "transmission" "plugdev" ];
      home = "/home/coconnor";
      shell = pkgs.bashInteractive + "/bin/bash";
    };
  };
}
