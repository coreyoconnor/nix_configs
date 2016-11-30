{config, pkgs, ...}:
{
  networking.firewall.allowedTCPPorts = [ 9091 ];

  services.transmission =
  {
    enable = true;
    settings =
    {
      rpc-whitelist = "127.0.0.1,192.168.*.*";
      download-dir = "/mnt/storage/media/Downloads";
      incomplete-dir = "/mnt/storage/media/Incomplete";
      incomplete-dir-enabled = true;
      umask = 2;
      encryption = 2;

      speed-limit-down = 100;
      speed-limit-down-enabled = true;
      speed-limit-up = 100;
      speed-limit-up-enabled = true;

      blocklist-url = "https://www.dropbox.com/s/2f8irg93zgglh2d/blocklist.txt?dl=1";
      blocklist-enabled = true;
    };
  };
}
