{
  config,
  pkgs,
  ...
}: {
  nixpkgs.config = {
    packageOverrides = in_pkgs: {
      linuxPackages =
        in_pkgs.linuxPackages_4_13.extend
        (selfLinux: superLinux: {
          zfs = pkgs.lib.overrideDerivation superLinux.zfs (oldAttrs: {
            patches = [./zfs.patch];
            src = pkgs.fetchFromGitHub {
              owner = "zfsonlinux";
              repo = "zfs";
              rev = "74ea6092d0693b6e1c6daaee0fdc79491697996c";
              sha256 = "194nq81wiwa6h07rq0h1p3mgpanlp6sy8knnsapw8606m2c7z84k";
            };
          });
        });
    };
  };
}
