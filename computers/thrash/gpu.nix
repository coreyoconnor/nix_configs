{ config, lib, pkgs, ... }: {
  hardware.opengl = {
    enable = true;
    driSupport = true;
    extraPackages = with pkgs; [
      amdvlk
    ];
  };

  programs.gamemode.enable = true;

  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" "modesetting" "vesa" ];
  };
}
