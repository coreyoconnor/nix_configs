{ config, lib, pkgs, ... }:

{
  nix.maxJobs = 2;
  nix.extraOptions = ''
    build-cores = 5
  '';

  security.pam.loginLimits = [{
    domain = "*";
    type = "soft";
    item = "nproc";
    value = "unlimited";
  }];

  hardware = {
    bluetooth.enable = true;
    enableAllFirmware = true;
    nvidia.nvidiaPersistenced = true;
    opengl.enable = true;
  };

  virtualisation.docker.storageDriver = "zfs";
}
