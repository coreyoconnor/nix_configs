{ config, pkgs, lib, ... } :
with lib;
let
  cfg = config.services.tensorderp;
  user = "jupyter";
  group = "jupyter";
  port = 10020;
  boardPort = 6006;
  home-dir = "/var/lib/jupyter";
  jupyter-service = pkgs.writeShellScript "tensorderp-jupyter-launcher" ''

mkdir -p ${home-dir}/notebooks

${pkgs.docker}/bin/docker run \
      -u $UID:$UID \
      --rm \
      -v ${home-dir}:/notebooks -w /notebooks \
      -p ${toString port}:${toString port} \
      -p ${toString boardPort}:${toString boardPort} \
      tensorflow/tensorflow:latest-py3-jupyter \
      jupyter-notebook \
        --ip=0.0.0.0 \
        --no-browser \
        -y \
        --notebook-dir=/notebooks \
        --port=${toString port} \
        --port-retries=0 \
        --NotebookApp.token= \
        --NotebookApp.password=
  '';
in {
  options = {
    services.tensorderp = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };
    };
  };

  config = mkIf cfg.enable {
    networking.firewall = {
        allowedTCPPorts = [ port boardPort ];
    };

    systemd.services."tensorderp-jupyter" = {
      description = "Serve tensorderp configured jupyter notebook";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = jupyter-service;
        Restart = "always";
        User = user;
        Group = group;
        WorkingDirectory = home-dir;
      };
    };

    users.groups.jupyter = {};

    users.extraUsers.jupyter = {
      createHome = true;
      extraGroups = [ group "docker" ];
      home = home-dir;
      useDefaultShell = true;
    };
  };
}
