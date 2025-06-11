{
  description = "example using coreyoconnor's nix_configs as a library";

  inputs = {
    nix_configs = {
      url = "github:coreyoconnor/nix_configs/dev";
    };
  };

  outputs = { self, nix_configs, ... }@inputs:
    nix_configs.lib.init {
      systems = {
        example = { system = "x86_84-linux"; };
      };
    };
}

