{ config, pkgs, lib, ... }:
with lib; {
  config = {

    environment.systemPackages = with pkgs; [
      acpi
      atk
      autoconf
      automake
      bashInteractive
      coq
      docker
      emacs
      ffmpeg
      fontconfig
      freetype
      fuse
      gcc
      gdb
      gettext
      glib
      glibcLocales
      gnumake
      gnupg
      irssi
      nginx
      nix-index
      # nixfmt
      ocaml
      openshift
      oprofile
      pkgconfig
      python
      ruby
      screen
      # TODO: move to desktop.nix without breaking existing configs in $HOME
      shared_desktop_ontologies
      shared_mime_info
      stdenv
      xterm
    ];
  };
}
