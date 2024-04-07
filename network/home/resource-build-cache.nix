{
  config,
  lib,
  pkgs,
  ...
}: let
  buildMachines = [
    {
      hostName = "ufo";
      sshUser = "nix";
      sshKey = "/root/.ssh/id_rsa";
      system = "i686-linux,x86_64-linux";
      maxJobs = 2;
      speedFactor = 100;
      supportedFeatures = ["kvm" "big-parallel"];
    }
    {
      hostName = "ufo";
      sshUser = "nix";
      sshKey = "/root/.ssh/id_rsa";
      system = "armv6l-linux,armv7l-linux,aarch64-linux,riscv32-linux,riscv64-linux,wasm32-wasi,wasm64-wasi";
      maxJobs = 1;
      speedFactor = 10;
      supportedFeatures = ["kvm"];
    }
  ];
in {
  nix = {
    distributedBuilds = true;
    buildMachines = buildMachines;
  };
}
