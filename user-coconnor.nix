{config, pkgs, ...}:
with pkgs.lib;
{
    # make sure a vboxusers group exists
    users.extraGroups = singleton { name = "vboxusers"; };

    users.extraUsers =
    { 
        coconnor = 
        { 
            createHome = true;
            group = "users";
            extraGroups = [ "wheel" "vboxusers" ];
            home = "/home/coconnor";
            shell = pkgs.bashInteractive + "/bin/bash";
        };
    };

}
