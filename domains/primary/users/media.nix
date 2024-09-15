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
      extraGroups = ["transmission" "plugdev" "audio" "video" "input" config.services.kubo.group];
      home = "/home/media";
      shell = pkgs.fish;
      openssh.authorizedKeys.keyFiles = [./ssh/coconnor.pub];
    };
  };
}
