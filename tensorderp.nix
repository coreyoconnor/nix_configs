{ config, pkgs, lib, ... } :
with lib;

# export LD_LIBRARY_PATH=/opengl-lib:$LD_LIBRARY_PATH
# --volume=/run/opengl-driver/lib:/opengl-lib:ro
let
  cfg = config.services.tensorderp;
  globalUser = "jupyter";
  globalGroup = "jupyter";
  globalUserHomeDir = "/var/lib/jupyter";
  notebookPort = 10020;
  tensorboardPort = 6006;
  globalJupyterServiceCPU = pkgs.writeShellScript "tensorderp-jupyter-launcher" ''

mkdir -p ${globalUserHomeDir}/notebooks

${pkgs.docker}/bin/docker run \
      -u $UID:$UID \
      --rm \
      -v ${globalUserHomeDir}:/notebooks -w /notebooks \
      -p ${toString notebookPort}:${toString notebookPort} \
      -p ${toString tensorboardPort}:${toString tensorboardPort} \
      tensorflow/tensorflow:latest-py3-jupyter \
      jupyter-notebook \
        --ip=0.0.0.0 \
        --no-browser \
        -y \
        --notebook-dir=/notebooks \
        --port=${toString notebookPort} \
        --port-retries=0 \
        --NotebookApp.token= \
        --NotebookApp.password=
  '';
  globalJupyterServiceGPU = pkgs.writeShellScript "tensorderp-jupyter-launcher" ''

mkdir -p ${globalUserHomeDir}/notebooks

${pkgs.nvidia-docker}/bin/nvidia-docker run \
      --gpus all
      -u $UID:$UID \
      --rm \
      -v ${globalUserHomeDir}:/notebooks -w /notebooks \
      -p ${toString notebookPort}:${toString notebookPort} \
      -p ${toString tensorboardPort}:${toString tensorboardPort} \
      tensorflow/tensorflow:latest-gpu-py3-jupyter \
      jupyter-notebook \
        --ip=0.0.0.0 \
        --no-browser \
        -y \
        --notebook-dir=/notebooks \
        --port=${toString notebookPort} \
        --port-retries=0 \
        --NotebookApp.token= \
        --NotebookApp.password=
  '';
  userJupyterServiceCPU = pkgs.writeShellScript "tensorderp-jupyter-launcher" ''

mkdir -p "$HOME/notebooks"

${pkgs.docker}/bin/docker run \
      -u $UID:$UID \
      --rm \
      -v "$HOME:/notebooks" -w /notebooks \
      -p ${toString notebookPort}:${toString notebookPort} \
      -p ${toString tensorboardPort}:${toString tensorboardPort} \
      tensorflow/tensorflow:latest-py3-jupyter \
      jupyter-notebook \
        --ip=0.0.0.0 \
        --no-browser \
        -y \
        --notebook-dir=/notebooks \
        --port=${toString notebookPort} \
        --port-retries=0 \
        --NotebookApp.token= \
        --NotebookApp.password=
  '';
  userJupyterServiceGPU = pkgs.writeShellScript "tensorderp-jupyter-launcher" ''

mkdir -p "$HOME/notebooks"
set -ex

${pkgs.nvidia-docker}/bin/nvidia-docker run \
      --gpus all \
      -u $UID:$UID \
      --rm \
      -v "$HOME:/notebooks" -w /notebooks \
      -p ${toString notebookPort}:${toString notebookPort} \
      -p ${toString tensorboardPort}:${toString tensorboardPort} \
      tensorflow/tensorflow:latest-gpu-py3-jupyter \
      jupyter-notebook \
        --ip=0.0.0.0 \
        --no-browser \
        -y \
        --notebook-dir=/notebooks \
        --port=${toString notebookPort} \
        --port-retries=0 \
        --NotebookApp.token= \
        --NotebookApp.password=
  '';
  cudatoolkitOverrides = super: rec {
    cudatoolkit = super.cudatoolkit_10;
  };
  commonConfig = {
    networking.firewall = {
        allowedTCPPorts = [ notebookPort tensorboardPort ];
    };

    users.groups.jupyter = {};

    users.extraUsers.jupyter = {
      createHome = true;
      extraGroups = [ globalGroup "docker" ];
      home = globalUserHomeDir;
      useDefaultShell = true;
    };
    nixpkgs.config =
    {
      packageOverrides = cudatoolkitOverrides;
    };
  };
  globalConfig = mkIf cfg.global {
    systemd.services."tensorderp-jupyter" = {
      description = "Serve tensorderp configured jupyter notebook";
      script = "${globalJupyterServiceGPU}";
      path = [ pkgs.docker ];

      after = [ "network.target" ];
      serviceConfig = {
        Restart = "always";
        User = globalUser;
        Group = globalGroup;
        WorkingDirectory = globalUserHomeDir;
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
  userConfig = mkIf (!cfg.global) {
    systemd.user.services."tensorderp-jupyter" = {
      description = "tensorderp-jupyter";
      script = "${userJupyterServiceGPU}";
      path = [ pkgs.docker ];

      serviceConfig = {
        Restart = "on-failure";
        PrivateTmp = true;
      };
      unitConfig = {
        ConditionGroup = "docker";
        ConditionUser = "!@system";
      };
      wantedBy = [ "default.target" ];
    };
  };
in {
  options = {
    services.tensorderp = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };

      global = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [commonConfig globalConfig userConfig]);
}
