self: super: rec {
  #promise = self.python3Packages.buildPythonPackage rec {
  #  pname = "promise";
  #  version = "2.2.1";
  #  src = self.python3Packages.fetchPypi {
  #    inherit pname version;
  #    sha256 = "0p35hm648gkxlmqki9js6xni6c8vmh1ysnnnkiyd8kyx7rn5z3rl";
  #  };
  #  doCheck = false;
  #  propagatedBuildInputs = with super.python3Packages; [
  #    six
  #  ];
  #};

  # tensorflow does not support python 3.8
  python3 = self.python37;

  tensorflowWithCudaCompute3 = self.python3Packages.tensorflow_2.override {
    cudaCapabilities = ["3.0"];
    cudaSupport = true;
    sse41Support = true;
    avxSupport = true;
    xlaSupport = false;
  };

  tensorflow-datasets = self.python3Packages.buildPythonPackage rec {
    pname = "tensorflow-datasets";
    version = "1.3.0";
    src = self.python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "0xy0y4w1h8dccrhxjqmk4fkcy5dh3afsaqcnh1nrxg3s7wqjka1x";
    };
    doCheck = false;
    buildInputs = [
      self.protobuf
    ];
    propagatedBuildInputs = with super.python3Packages; [
      attrs
      dill
      promise
      protobuf
      requests
      tensorflow-metadata
      tensorflowWithCudaCompute3
      future
      tqdm
    ];
    meta = {
      homepage = "https://www.tensorflow.org/datasets";
      description = "A collection of datasets ready to use with TensorFlow.";
    };
  };

  tensorflow-metadata = self.python3Packages.buildPythonPackage rec {
    pname = "tensorflow-metadata";
    version = "0.15.1";
    src = self.fetchFromGitHub {
      owner = "tensorflow";
      repo = "metadata";
      rev = "aa93a557e61cd8c8c9a2348809cf3a4717fe30ce";
      sha256 = "1cj11z3rd6frv4fsz49ba5yp847q3yzfpn8gnr4rdnwvs7xx9af6";
    };
    doCheck = false;
    buildInputs = [
      self.protobuf
    ];
    preBuild = ''
      ${self.protobuf}/bin/protoc \
         --python_out=. \
        tensorflow_metadata/proto/v0/*.proto
    '';
    propagatedBuildInputs = with super.python3Packages; [
      googleapis_common_protos
      google_api_core
      protobuf
    ];
    meta = {
      homepage = "https://www.tensorflow.org/";
      description = ''
        TensorFlow Metadata provides standard representations for metadata that are useful when
        training machine learning models with TensorFlow.
      '';
    };
  };
}
