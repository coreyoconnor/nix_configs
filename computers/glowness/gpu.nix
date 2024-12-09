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

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
      ];
    };

    hardware.amdgpu = {
      amdvlk = {
        enable = true;
        support32Bit.enable = true;
      };
      opencl.enable = true;
      initrd.enable = true;
    };

    systemd.tmpfiles.rules = [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];

    programs.gamemode.enable = true;
  };
}
