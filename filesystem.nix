{config, pkgs, ...}:
{
  fileSystems."/" =
  { device = "/dev/disk/by-label/root";
    options = "rw,data=ordered,relatime";
    fsType = "ext4";
  };

  swapDevices =
  [ 
    { device = "/dev/disk/by-label/swap"; }
  ];
}
