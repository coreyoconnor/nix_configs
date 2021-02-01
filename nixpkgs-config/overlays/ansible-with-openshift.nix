self: super:
let
  ansible-pythonpath = self.python3Packages.makePythonPath [
    super.ansible self.python3Packages.urllib3 self.python3Packages.docker
  ];
  ansible-python-support-pkgs = python-packages: with python-packages; [
    pip
    virtualenvwrapper
  ];
in rec {
  ansible = self.python3Packages.toPythonApplication (self.python3Packages.ansible.overridePythonAttrs(old: rec {
    propagatedBuildInputs = with self.python3Packages; old.propagatedBuildInputs ++ [
    ];
    makeWrapperArgs = [ "--set PYTHONPATH ${ansible-pythonpath}" ];
  }));

  ansible-bender = self.python3Packages.buildPythonPackage rec {
    pname = "ansible-bender";
    version = "0.8.1";
    src = self.python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "0q9ah1kfp0rax3lkbvyx5nk525ccaphabd7r8da0g197idflwczx";
    };
    nativeBuildInputs = with self.python3Packages; [ setuptools_scm ];

    postPatch = ''
      substituteInPlace setup.cfg \
        --replace "setuptools_scm_git_archive" ""
    '';

    propagatedBuildInputs = with self.python3Packages ; [
      ansible jsonschema pyyaml tabulate
    ];

    doCheck = false;
    checkInputs = with self.python3Packages ; [
      flexmock pytest
    ];
  };

  ansible-python-support = self.python3.withPackages ansible-python-support-pkgs;
}
