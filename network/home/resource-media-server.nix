{
  config,
  lib,
  pkgs,
  ...
}: {
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "create mask" = "0664";
        "directory mask" = "0775";
        "server role" = "standalone";
        "guest account" = "media";
        "map to guest" = "bad user";
        "security" = "auto";
      };
      media = {
        "path" = "/mnt/storage/media";
        "comment" = "Public media";
        "browseable" = "yes";
        "writeable" = "yes";
        "guest ok" = "yes";
        "guest only" = "yes";
      };
    };
  };
}
