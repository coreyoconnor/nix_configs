{ config, lib, pkgs, ... }: {
  hardware.opengl = {
    enable = true;
    driSupport = true;
    extraPackages = with pkgs; [
      amdvlk
    ];
  };

  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" "modesetting" "vesa" ];
  };
}
