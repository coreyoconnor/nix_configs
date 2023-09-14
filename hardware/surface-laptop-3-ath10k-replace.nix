{ stdenv, lib, pkgs, firmwareLinuxNonfree, ... }:

let
  repos = pkgs.callPackage ../dependencies/nixos-hardware/microsoft/surface/common/repos.nix {};

  board_firmware = 
    repos.ath10k-firmware-override + "/ath10k-firmware-override/main/board-2.bin";
  firmware_firmware = 
    repos.ath10k-firmware + "/QCA6174/hw3.0/4.4.1/firmware-6.bin_WLAN.RM.4.4.1-00132-QCARMSWP-1";

in stdenv.mkDerivation {
  pname = "microsoft-surface-go-firmware-linux-nonfree";
  inherit (firmwareLinuxNonfree) version;
  src = firmwareLinuxNonfree;
  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    # Install the Surface Go Wifi firmware:
    cp ${board_firmware} lib/firmware/ath10k/QCA6174/hw3.0/board-2.bin
    cp ${firmware_firmware} lib/firmware/ath10k/QCA6174/hw3.0/firmware-6.bin

    mkdir $out; cp -r ./. $out
  '';

  meta = with lib; {
    description = "Standard binary firmware collection, adjusted with the Surface Laptop 3 WiFi firmware";
    platforms = platforms.linux;
    priority = 5;
  };
}
