{ config, pkgs, lib, ... } :

with lib;
let
  cfg = config.vmhost.vfio;
  forceBindScript = ''
    set -ex
    for dev in ${concatStringsSep " " cfg.forceBinds}; do
      vendor=$(cat /sys/bus/pci/devices/$dev/vendor)
      device=$(cat /sys/bus/pci/devices/$dev/device)
      if [ -e /sys/bus/pci/devices/$dev/driver ]; then
        echo $dev > /sys/bus/pci/devices/$dev/driver/unbind
        echo $vendor $device > /sys/bus/pci/drivers/vfio-pci/new_id
      fi
    done
  '';
  commonParams = [ "kvm.emulate_invalid_guest_state=1" "kvm.ignore_msrs=1" ];
  iommuParamsFor =
  {
    intel = [ "intel_iommu=on" ];
  };
  iommuParams = iommuParamsFor.${cfg.iommu};
  bootBindPciIds = cfg.bootBinds ++ cfg.nvidiaBinds;
  vfioPciIdsParam = "vfio_pci.ids=" + (concatStringsSep "," bootBindPciIds);
  bootBindParams = [ vfioPciIdsParam ];
  nvidiaParams = if length cfg.nvidiaBinds > 0 then [ "nomodeset" ] else [ ];
  kernelParams = commonParams ++ iommuParams ++ bootBindParams ++ nvidiaParams;
  blacklistedNvidiaModules = if length cfg.nvidiaBinds > 0 then [ "nouveau" ] else [ ];
  blacklistedKernelModules = blacklistedNvidiaModules;
in {
  options =
  {
    vmhost.vfio =
    {
      enable = mkOption
      {
        type = types.bool;
        default = false;
      };

      forceBinds = mkOption
      {
        type = types.listOf types.string;
        default = [];
        example = [ "0000:08:00.0" ];
      };

      bootBinds = mkOption
      {
        type = types.listOf types.string;
        default = [];
        example = [ "10de:17c8" ];
      };

      iommu = mkOption
      {
        type = types.enum [ "none" "intel" ];
        default = "none";
        example = "intel";
      };

      nvidiaBinds = mkOption
      {
        type = types.listOf types.str;
        default = [];
        example = [ "10de:17c8" "10de:0fb0" ];
      };
    };
  };

  config = mkIf cfg.enable
  {
    boot =
    {
      kernelModules =
      [
        "vfio"
        "vfio_pci"
        "vfio_iommu_type1"
        "vfio_virqfd"
        "pci_stub"
      ];

      inherit blacklistedKernelModules kernelParams;
    };

    systemd.services.vfio-force-binds =
    {
      description = "Forcefully unbinds the given PCI devices then binds to VFIO";
      before = [ "libvirtd.service" ];
      wantedBy = [ "libvirtd.service" ];
      after = [ "systemd-udev-settle.service" ];

      restartIfChanged = false;

      path = [ pkgs.pciutils ];
      serviceConfig =
      {
        Type = "oneshot";
      };
      script = forceBindScript;
    };
  };
}
