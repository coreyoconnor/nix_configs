{config, pkgs, ...}:

{
    require = [ <nixos/modules/programs/virtualbox.nix> ];

    environment.systemPackages =
    [
        pkgs.kvm
    ];
}

