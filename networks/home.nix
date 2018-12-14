{config, pkgs, ...}:
{
  imports =
  [
    ./known-hosts.nix
    ../users/admin.nix
    ../users/bretto.nix
    ../users/coconnor.nix
    ../users/jenkins.nix
    ../users/media.nix
    ../users/nix.nix
  ];

  config =
  {
    networking =
    {
      extraHosts = ''
        192.168.1.2 agh
        192.168.1.3 waffle
        192.168.1.4 ufo
        192.168.1.5 thrash
        192.168.1.6 alter
        192.168.1.7 grr
        192.168.1.8 kahn
        192.168.1.9 blep
        192.168.1.17 grr-alt
      '';
    };

    security.pki.certificateFiles = [ ./agh-0.crt ];
  };
}
