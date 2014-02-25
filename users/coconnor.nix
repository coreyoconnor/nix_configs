{config, pkgs, ...}:
with pkgs.lib;
{
  # make sure the required groups exist
  users.extraGroups =
  [
    { name = "plugdev"; gid = 10001; }
  ];

  users.extraUsers =
  { 
    coconnor = 
    { 
      createHome = true;
      uid = 499;
      group = "users";
      extraGroups = [ "wheel" "vboxusers" "transmission" "plugdev" "audio" ];
      home = "/home/coconnor";
      shell = pkgs.bashInteractive + "/bin/bash";
    };
  };
}
