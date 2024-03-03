{
  config,
  pkgs,
  ...
}:
with pkgs.lib; {
  users.users = {
    media = {
      isNormalUser = true;
      createHome = true;
      uid = 1001;
      group = "users";
      extraGroups = ["transmission" "plugdev" "audio" "video" "input"];
      home = "/home/media";
      shell = pkgs.bashInteractive + "/bin/bash";
      openssh.authorizedKeys.keyFiles = [./ssh/coconnor.pub];
    };
  };
}
