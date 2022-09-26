{ config, pkgs, ... }:
{
  config = {

    environment.etc."containers/policy.json" = {
      mode="0644";
      text=''
        {
          "default": [
            {
              "type": "insecureAcceptAnything"
            }
          ],
          "transports":
          {
            "docker-daemon":
            {
              "": [{"type":"insecureAcceptAnything"}]
            }
          }
        }
      '';
    };

    environment.etc."containers/registries.conf" = {
      mode="0644";
      text=''
        [registries.search]
          registries = ['docker.io', 'quay.io']
      '';
    };
  };
}
