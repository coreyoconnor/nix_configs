{
  config,
  pkgs,
  ...
}:
with pkgs.lib; {
  # make sure the required groups exist
  users.groups.plugdev = {
    gid = 10001;
  };

  users.users = {
    coconnor = {
      isNormalUser = true;
      createHome = false;
      uid = 1100;
      group = "users";
      extraGroups = [
        "audio"
        "dialout"
        "docker"
        "jupyter"
        "libvirtd"
        "monkey"
        "plugdev"
        "systemd-journal"
        "transmission"
        "vboxusers"
        "video"
        "wheel"
        config.services.kubo.group
      ];
      home = "/home/coconnor";
      shell = pkgs.fish;
      openssh.authorizedKeys.keyFiles = [./ssh/coconnor.pub];
      subUidRanges = [
        {
          startUid = 2000000;
          count = 65536;
        }
      ];
      subGidRanges = [
        {
          startGid = 2000000;
          count = 65536;
        }
      ];
    };
  };
}
