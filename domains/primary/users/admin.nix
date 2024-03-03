{
  config,
  pkgs,
  ...
}:
with pkgs.lib; {
  users.users = {
    admin = {
      isNormalUser = true;
      createHome = true;
      uid = 1000;
      group = "users";
      extraGroups = ["wheel" "libvirtd" "vboxusers"];
      home = "/home/admin";
      shell = pkgs.bashInteractive + "/bin/bash";
      openssh.authorizedKeys.keyFiles = [./ssh/coconnor.pub];
    };
  };
}
