let
  knownHosts = {
    github = {
      hostNames = ["github.com"];
      publicKeyFile = ./known-hosts/github.com.pub;
    };

    grr = {
      hostNames = ["grr"];
      publicKeyFile = ./known-hosts/grr.pub;
    };

    gitlab = {
      hostNames = ["gitlab.com"];
      publicKeyFile = ./known-hosts/gitlab.com.pub;
    };
  };
in {
  imports = [];

  config = {
    networking = {
      extraHosts = ''
        192.168.86.2 agh
        192.168.86.3 glowness
        192.168.86.5 thrash
        192.168.86.6 ufo
        192.168.86.7 grr
        192.168.86.8 deny
        192.168.86.17 grr-alt
        192.168.86.8 atomicpi
      '';
    };

    programs.ssh.knownHosts = knownHosts;

    services.avahi.publish = {
      enable = true;
      domain = true;
    };
  };
}
