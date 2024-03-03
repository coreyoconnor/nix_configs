{
  config,
  pkgs,
  ...
}:
with pkgs.lib; {
  users.extraUsers = {
    bretto = {
      isNormalUser = true;
      extraGroups = ["libvirtd" "transmission" "systemd-journal"];
      shell = pkgs.bashInteractive + "/bin/bash";
      openssh.authorizedKeys.keyFiles = [./ssh/brett.pub];
    };
  };
}
