let
  knownHosts = {
    github = {
      hostNames = ["github.com"];
      publicKeyFile = ./known-hosts/github.com.pub;
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
        192.168.88.4 ufo
        192.168.88.18 glowness
        192.168.88.23 deny
        192.168.88.30 thrash
      '';
    };

    programs.ssh.knownHosts = knownHosts;

    services.avahi.publish = {
      enable = true;
      domain = true;
    };
  };
}
