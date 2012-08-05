{ config, pkgs, ... } :

with pkgs.lib;

{
    config =
    {
        nixpkgs.config.packageOverrides = pkgs : 
        { 
            kde4 = pkgs.kde48;
        };

        environment.x11Packages = 
        [ 
            pkgs.kde4.calligra
            pkgs.kde4.kdelibs
            pkgs.kde4.kde_runtime
            pkgs.kde4.oxygen_icons
        ];

        services.xserver.displayManager.kdm.enable = true;
        services.xserver.desktopManager.kde4.enable = true;
    };
}

