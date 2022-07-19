{ config, lib, pkgs, ... }:
let
  grrBuildMachines = [
    {
      hostName = "grr";
      sshUser = "nix";
      sshKey = "/root/.ssh/id_rsa";
      system = "i686-linux,x86_64-linux";
      maxJobs = 8;
      speedFactor = 2;
    }
    {
      hostName = "grr";
      sshUser = "nix";
      sshKey = "/root/.ssh/id_rsa";
      system =
        "armv6l-linux,armv7l-linux,aarch64-linux,riscv32-linux,riscv64-linux,wasm32-wasi,wasm64-wasi";
      maxJobs = 2;
      speedFactor = 1;
    }
  ];
in {
  services.nix-serve = {
    enable = true;
    port = 4999;
    secretKeyFile = "/etc/nix/agh-nix-serve-1.sec";
    extraParams = "-E development";
  };

  nix = {
    distributedBuilds = true;
    buildMachines = grrBuildMachines;
    extraOptions = ''
      secret-key-files = /etc/nix/agh-1.pem
      keep-outputs = true
    '';
  };
}
