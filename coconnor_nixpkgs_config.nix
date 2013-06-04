{ pkgs, ... } :

{
    packageOverrides = pkgs :
    {
        emacsDevEnv = pkgs.myEnvFun
        {
            name = "emacs";
            buildInputs = 
            [ 
                pkgs.stdenv
                pkgs.autoconf
                pkgs.automake
                pkgs.ncurses 
                pkgs.x11 
                pkgs.texinfo 
                pkgs.xlibs.libXaw 
                pkgs.xlibs.libXpm 
                pkgs.libpng
                pkgs.libjpeg 
                pkgs.libungif
                pkgs.libtiff 
                pkgs.librsvg 
                pkgs.xlibs.libXft 
                pkgs.gnome.GConf 
                pkgs.libxml2 
                pkgs.imagemagickBig 
                pkgs.gnutls
                pkgs.alsaLib
                pkgs.gtkLibs.gtk 
                pkgs.pkgconfig
                pkgs.dbus
            ];
        };

        rubySqlite3Dev = pkgs.myEnvFun
        {
            name = "sqlite3-ruby";
            buildInputs = 
            [ 
                pkgs.stdenv
                pkgs.autoconf
                pkgs.automake
                pkgs.ruby 
                pkgs.sqlite 
            ];
        };
        
        rubyNokogiriDev = pkgs.myEnvFun
        {
            name = "nokogiri-ruby";
            buildInputs = 
            [ 
                pkgs.stdenv
                pkgs.autoconf
                pkgs.automake
                pkgs.ruby 
                pkgs.libxml2 
                pkgs.libxslt
            ];
        };

        rubyTyphoeusDev = pkgs.myEnvFun
        {
            name = "typhoeus-ruby";
            buildInputs = 
            [ 
                pkgs.stdenv
                pkgs.autoconf
                pkgs.automake
                pkgs.ruby 
                pkgs.curl
            ];
        };
    };
}

