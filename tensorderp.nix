{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.services.tensorderp;
  jupyterConfig = config.services.jupyter;
  notebookPort = 10020;
  shareGroup = "jupyter";
  tensorboardPort = 6006;
  setupNotebookDir = ''
    mkdir -p "${jupyterConfig.notebookDir}"
    chown ${jupyterConfig.user}:${shareGroup} "${jupyterConfig.notebookDir}"
    chmod ug+rwx "${jupyterConfig.notebookDir}"
    chmod g+s "${jupyterConfig.notebookDir}"
    mkdir -p ~/.jupyter/nbconfig/notebook.d/
    mkdir -p ~/.local/share/jupyter/runtime
    cp -f ${pkgs.python3Packages.widgetsnbextension}/etc/jupyter/nbconfig/notebook.d/*.json \
       ~/.jupyter/nbconfig/notebook.d/
  '';
in {
  options = {
    services.tensorderp = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPorts = [ notebookPort tensorboardPort ];
    };

    services.jupyter = {
      enable = true;
      ip = "0.0.0.0";
      kernels = {
          python3 = let
            env = (pkgs.python3.withPackages (ps: with ps; [
                    ipykernel
                    ipywidgets
                    widgetsnbextension
                    pandas
                    scikitlearn
                    gdal
                    numpy
                    scikitimage
                    setuptools
                    pkgs.tensorflowWithCudaCompute3
                    pkgs.tensorflow-datasets
                  ]));
          in {
            displayName = "Python 3";
            argv = [
              env.interpreter
              "-m"
              "ipykernel_launcher"
              "-f"
              "{connection_file}"
            ];
            language = "python";
            # TODO: invalid type error with the icons included
            # logo32 = "${env.sitePackages}/ipykernel/resources/logo-32x32.png";
            # logo64 = "${env.sitePackages}/ipykernel/resources/logo-64x64.png";
          };
        };
      port = notebookPort;
      notebookConfig = ''
        c.NotebookApp.token = ""
      '';
      notebookDir = "/var/lib/jupyter";
      password = "''";
    };
    users.extraUsers.jupyter.extraGroups = [ "docker" ];
    systemd.services.jupyter = {
      preStart = setupNotebookDir;
      environment = {
        # JUPYTER_DATA_DIR = "${pkgs.python3Packages.widgetsnbextension}/share/jupyter";
        # JUPYTER_RUNTIME_DIR = "~/.local/share/jupyter/runtime";
      };
      path = [ pkgs.bash pkgs.jdk ];
      serviceConfig = {
        UMask = "0002";
      };
    };
  };
}
