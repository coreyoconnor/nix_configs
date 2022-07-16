{ config, lib, pkgs, ... }: {
  networking = {
    defaultGateway = "192.168.86.1";
    nameservers = [ "192.168.86.2" "1.1.1.1" ];
  };
}
