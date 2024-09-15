{
  config,
  pkgs,
  ...
}:
with pkgs.lib; {
  users.groups = {
    monkey = {};
  };

  users.users = {
    monkey = {
      isSystemUser = true;

      createHome = true;
      home = "/home/monkey";

      group = "monkey";
      extraGroups = ["libvirtd" "docker"];
      subUidRanges = [
        {
          startUid = 2100000;
          count = 65536;
        }
      ];
      subGidRanges = [
        {
          startGid = 2100000;
          count = 65536;
        }
      ];

      openssh.authorizedKeys.keyFiles = [./ssh/coconnor.pub];
    };
  };
}
