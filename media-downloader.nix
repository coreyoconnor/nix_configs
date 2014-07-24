{config, pkgs, ...}:
{
  systemd.mounts =
  [
    {
      what = "//192.168.1.10/media";
      where = "/mnt/nomnom/media";
      type = "cifs";
      options = "guest,sec=ntlm";
      requiredBy = ["transmission.service"];
      wants = ["network-online.target"];
    }
  ];

  networking.firewall.allowedTCPPorts = [ 9091 ];

  services.transmission =
  {
    enable = true;
    settings =
    {
      rpc-whitelist = "127.0.0.1,192.168.*.*";
      umask = 2;
      download-dir = "/mnt/nomnom/media/Downloads";
    };
  };
}
