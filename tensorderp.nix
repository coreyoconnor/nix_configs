{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.services.tensorderp;
  notebookPort = 10020;
  tensorboardPort = 6006;
  commonConfig = {
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
                    pandas
                    scikitlearn
                    gdal
                    numpy
                    scikitimage
                    (tensorflowWithCuda.override {
                      avxSupport = true;
                      cudaCapabilities = [ "3.0" ];
                      sse41Support = true;
                      sse42Support = true;
                      xlaSupport = false;
                    })
                  ]));
          in {
            displayName = "Python 3 with machine learning prelude";
            argv = [
              env.interpreter
              "-m"
              "ipykernel_launcher"
              "-f"
              "{connection_file}"
            ];
            language = "python";
            # logo32 = "${env.sitePackages}/ipykernel/resources/logo-32x32.png";
            # logo64 = "${env.sitePackages}/ipykernel/resources/logo-64x64.png";
          };
        };
      port = notebookPort;
      notebookConfig = ''
        c.NotebookApp.token = ""
      '';
      password = "''";
    };
    users.extraUsers.jupyter.extraGroups = [ "docker" ];
    systemd.services.jupyter = {
      environment = {
        LD_LIBRARY_PATH = "/run/opengl-driver";
      };
      path = [ pkgs.python3 ];
      serviceConfig = {
        UMask = "0002";
      };
    };
  };
  globalConfig = mkIf cfg.global {
  };
  userConfig = mkIf (!cfg.global) {
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

  config = mkIf cfg.enable (mkMerge [ commonConfig globalConfig userConfig ]);
}
