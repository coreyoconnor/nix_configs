self: super:
let
  launcher = self.writeShellScript "tensorderp-launcher" ''
    nix-shell --cores 16 '<nixpkgs>' -A tensorderp-shell
  '';
  version = "0.1.0";
in rec {
  cudatoolkit = super.cudatoolkit_10;

  tensorderp-shell = self.python3Packages.buildPythonApplication {
    pname = "tensorderp-shell";
    inherit version;

    propagatedBuildInputs = with self.python3Packages; [
      gdal
      (matplotlib.override { enableGtk3 = true; })
      numpy
      scikitimage
      tensorflowWithCudaCompute3
    ];

    builder = self.writeShellScript "builder.sh" ''
      echo none
    '';

    shellHook = ''
      unset SOURCE_DATE_EPOCH
      export PIP_PREFIX="$HOME/.cache/tensorderp/pip_packages"
      mkdir -p "$PIP_PREFIX"
      python_path=( "$PIP_PREFIX/lib/python3.7/site-packages"
                    "$PYTHONPATH" )
      IFS=: eval 'python_path="''${python_path[*]}"'
      export PYTHONPATH="$python_path"
      export MPLBACKEND='Gtk3Agg'
    '';
  };

  tensorderp = self.stdenv.mkDerivation {
    pname = "tensorderp";
    inherit version;

    buildInputs = [ self.stdenv ];

    builder = self.writeShellScript "builder.sh" ''
      source $stdenv/setup
      mkdir -p $out/bin
      ln -s ${launcher} $out/bin/tensorderp
    '';
  };
}
