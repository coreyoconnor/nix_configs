{
  nixpkgs,
  deploy-rs,
  ...
}:
with nixpkgs.lib; { self, ...} @ inputs: let
  # I was running into issues with recursion if inputs to nixosSystem included self.
  inputsMinusSelf = builtins.removeAttrs inputs ["self"];
  nixosConfiguration = {
    name,
    system,
    configPath ? "${self}/computers/${name}",
    ...
  }:
    nixosSystem {
      specialArgs = inputsMinusSelf // {inputs = inputsMinusSelf;};
      modules = [self.nixosModules.default configPath { networking.hostName = nixpkgs.lib.mkDefault name; }];
      inherit system;
    };
  nixosActivation = systemName: systemConfig: ({
      hostname = systemName;
      profiles.system = {
        user = "root";
        path = deploy-rs.lib.${systemConfig.system}.activate.nixos self.nixosConfigurations.${systemName};
      };
    }
    // systemConfig);
  nixosConfigurationWithName = systemName: systemConfig: nixosConfiguration ({name = systemName;} // systemConfig);
  nixosConfigurations = nodes: builtins.mapAttrs nixosConfigurationWithName nodes;
  nixosActivations = nodes: builtins.mapAttrs nixosActivation (
    attrsets.filterAttrs (systemName: systemConfig:
      if (systemConfig ? "imageBuild") then !systemConfig.imageBuild else true
    ) nodes
  );
  allSystemsUsing = system:
    nixpkgs.legacyPackages.${system}.linkFarm "all-nixos-configurations" (
      nixpkgs.lib.mapAttrsToList (
        node: nixosSystem: {
          name = node;
          path =
            if (nixpkgs.lib.hasSuffix "-image" node)
            then nixosSystem.config.system.build.sdImage
            else if (nixpkgs.lib.hasSuffix "-iso" node)
            then nixosSystem.config.system.build.isoImage
            else nixosSystem.config.system.build.toplevel;
        }
      )
      self.nixosConfigurations
    );
  in {
    inherit
      allSystemsUsing
      nixosActivation
      nixosActivations
      nixosConfiguration
      nixosConfigurations;

    devshellImport = import ./mkDevshellImport.nix nixpkgs inputsMinusSelf;

    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };
