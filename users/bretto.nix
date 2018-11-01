{config, pkgs, ...}:
with pkgs.lib;
{
  users.extraUsers =
  {
    bretto =
    {
      createHome = true;
      group = "users";
      extraGroups = [ "libvirtd"
                      "transmission" ];
      shell = pkgs.bashInteractive + "/bin/bash";
      openssh.authorizedKeys.keyFiles = [./ssh/brett.pub];
    };
  };
}
