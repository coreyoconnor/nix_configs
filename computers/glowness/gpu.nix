{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  imports = [
  ];

  config = {
    boot = {
      kernelParams = ["amdgpu.mcbp=0" "amd_iommu=off"];
    };

    hardware = {
      opengl = {
        enable = true;
        driSupport32Bit = true;
        extraPackages = with pkgs; [
          vaapiVdpau
          libvdpau-va-gl
        ];
      };
    };

    programs.gamemode.enable = true;
  };
}
