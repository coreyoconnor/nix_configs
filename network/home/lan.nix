{ config, lib, pkgs, ... }: {
  networking = {
    defaultGateway = "192.168.86.1";
    nameservers = [ "1.1.1.1" "192.168.86.2" ];
  };
}
