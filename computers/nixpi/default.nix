let system = "armv6l-linux"; in
let
  pkgsFun = import ../../nixpkgs;
  pkgsNoParams = pkgsFun {};
  crossPkgsFun = pkgsFun
  {
    crossSystem =
    {
      config = "armv6l-unknown-linux-gnueabi";
      bigEndian = false;
      arch = "arm";
      float = "hard";
      fpu = "vfp";
      withTLS = true;
      libc = "glibc";
      platform = pkgsNoParams.platforms.raspberrypi;
      openssl.system = "linux-generic32";
      gcc =
      {
        arch = "armv6";
        fpu = "vfp";
        float = "softfp";
        abi = "aapcs-linux";
      };
    };

    config = pkgs:
    {
      packageOverrides = pkgs :
      {
        distccMasquerade = pkgs.distccMasquerade.override
        {
          gccRaw = pkgs.gccCrossStageFinal.gcc;
          binutils = pkgs.binutilsCross;
        };
      };
    };
  };
  eval = (import ../../nixpkgs/nixos/lib/eval-config.nix
    {
      inherit system;
      modules = [ ./configuration.nix ];
    });
in {
  
}
