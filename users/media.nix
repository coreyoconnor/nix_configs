{config, pkgs, ...}:
with pkgs.lib;
{
  users.extraUsers =
  { 
    media = 
    { 
      createHome = true;
      uid = 1001;
      group = "users";
      extraGroups = ["transmission" "plugdev" "audio" "video"];
      home = "/home/media";
      shell = pkgs.bashInteractive + "/bin/bash";
      openssh.authorizedKeys.keyFiles = [./ssh/coconnor.pub];
    };
  };
}
