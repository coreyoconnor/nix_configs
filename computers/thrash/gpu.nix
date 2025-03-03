{
  config,
  lib,
  pkgs,
  ...
}: {
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  hardware.amdgpu = {
    opencl.enable = true;
    initrd.enable = true;
  };

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  programs.gamemode.enable = false;
}
