{
  config,
  lib,
  pkgs,
  ...
}: {
  services.samba = {
    enable = true;
    securityType = "auto";
    openFirewall = true;
    extraConfig = ''
      create mask = 0664
      directory mask = 0775
      server role = standalone
      guest account = media
      map to guest = bad user
    '';
    shares = {
      media = {
        path = "/mnt/storage/media";
        comment = "Public media";
        "writeable" = true;
        "guest ok" = true;
        "guest only" = true;
      };
    };
  };
}
