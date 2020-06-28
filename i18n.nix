{ config, pkgs, ... }: {
  console = {
    font = "lat9w-16";
    keyMap = "emacs2";
  };
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };
}
