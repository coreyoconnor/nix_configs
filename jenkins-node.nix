{config, pkgs, ...}:
with pkgs.lib;
{
  users.jenkins =
  {
    enable = true;
    extraGroups = [ "vboxusers" ];
  };

  fonts.enableFontDir = true;
  services.xfs.enable = true;

  # control password: control
  # view only password: viewonly
  systemd.services.jenkins-X11 =
  {
    description = "X11 vnc for jenkins";
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.xorg.xorgserver pkgs.tightvnc pkgs.dwm ];
    environment =
    {
      DISPLAY = ":10";
    };
    script = ''
      set -ex
      mkdir -p ~/.vnc
      cp -f ${./jenkins-vnc-passwd} ~/.vnc/passwd
      chmod go-rwx ~/.vnc/passwd
      echo > ~/.vnc/xstartup
      chmod u+x ~/.vnc/xstartup
      vncserver $DISPLAY -geometry 1280x1024 -depth 24 -name jenkins -ac
      dwm
    '';
    preStop = ''
      vncserver -kill $DISPLAY
    '';
    serviceConfig = {
      User = "jenkins";
    };
  };

  systemd.services.selenium-server =
  {
    description = "selenium-server";
    wantedBy = [ "multi-user.target" ];
    requires = [ "jenkins-X11.service" ];
    path = [ pkgs.jre
             pkgs.chromedriver
             pkgs.chromium
             pkgs.firefox ];
    environment =
    {
      DISPLAY = ":10";
    };
    script = ''
      java -jar ${pkgs.seleniumServer} -Dwebdriver.enable.native.events=1
    '';
    serviceConfig = {
      User = "jenkins";
    };
  };
}
