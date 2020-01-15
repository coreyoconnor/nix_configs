{ config, pkgs, ... }:
let
  knownHosts = {
    github = {
      hostNames = [ "github.com" ];
      publicKeyFile = ./known-hosts/github.com.pub;
    };
    private = {
      hostNames = [ "private" ];
      publicKeyFile = ./known-hosts/private.pub;
    };
    coreyoconnor-com = {
      hostNames = [ "public" "coreyoconnor.com" ];
      publicKeyFile = ./known-hosts/coreyoconnor.com.pub;
    };
    grr = {
      hostNames = [ "grr" ];
      publicKey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILUlJcqRuWcYIam0Vyq7GDLa8eLnkEfOc954cMqT18td root@grr";
    };
    gitlab = {
      hostNames = [ "gitlab.com" "52.167.219.168" ];
      publicKeyFile = ./known-hosts/gitlab.com.pub;
    };
  };
in { config = { programs.ssh.knownHosts = knownHosts; }; }
