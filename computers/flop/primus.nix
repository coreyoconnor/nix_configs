{ config, pkgs, ... } :

with pkgs.lib;

{
  options =
  {
    hardware.enableAcerPrimus = mkOption
    {
      default = false;
      example = true;
      type = with types; bool;
      description = ''
        Enable primus support for acer laptop
      '';
    };
  };

  config = mkMerge
  [
    (mkIf config.hardware.enableAcerPrimus
    {
      #boot.kernelParams = ["rcutree.rcu_idle_gp_delay=1"];

      hardware.bumblebee.enable = true;
      #services.udev.extraRules = ''
      #  KERNEL=="card1", SUBSYSTEM="kvm", ENV{ID_SEAT}="seat8"
      #  KERNEL=="card0", SUBSYSTEM="kvm", ENV{ID_SEAT}="seat1"
      #  ATTRS{vendor}=="0x8086", ATTRS{subsystem_device}=="0x079b", ENV{ID_SEAT}="seat1"
      #  ATTRS{vendor}=="0x10de", ATTRS{subsystem_device}=="0x079b", ENV{ID_SEAT}="seat8"
      #'';

      services.xserver =
      {
        # prevent the nvidia card being added automatically.
        # otherwise there is a race between bumblebeed's X11 and the primary.
        #serverFlagsSection = ''
        #  Option "AutoAddGPU" "off"
        #'';

        #serverLayoutSection = ''
        #  Option "SingleCard" "true"
        #'';

        #deviceSection = ''
        #  BusID "PCI:0:2:0"
        #'';
      };
    })

    (mkIf (config.hardware.enableAcerPrimus == false)
    {
      hardware.nvidiaOptimus.disable = true;
    })
  ];
}

