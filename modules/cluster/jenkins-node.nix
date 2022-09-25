{ config, lib, pkgs, modulesPath, ... }:
with lib; {
  imports = [
  ];

  options.cluster.jenkins-node = {
    enable = mkOption {
      default = false;
      example = true;
      type = with types; bool;
    };
  };

  config = mkIf config.cluster.jenkins-node.enable {
    # services.jenkinsSlave.enable = true;
    users.extraUsers.jenkins.extraGroups = [ "libvirtd" "vboxusers" "plugdev" ];

    fonts.fontDir.enable = true;

    services.clamav = {
      daemon.enable = true;
      updater.enable = true;
    };
  };
}
