self: super:
let
  ansible-pythonpath = self.python3Packages.makePythonPath [
    super.ansible self.python3Packages.urllib3 self.python3Packages.docker self.openshift-python-client
  ];
  ansible-python-support-pkgs = python-packages: with python-packages; [
    pip
    virtualenvwrapper
  ];
in rec {
  ansible = self.python3Packages.toPythonApplication (self.python3Packages.ansible.overridePythonAttrs(old: rec {
    propagatedBuildInputs = with self.python3Packages; old.propagatedBuildInputs ++ [
      openshift-python-client
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

  python-dictdiffer = self.python3Packages.buildPythonPackage rec {
    pname = "dictdiffer";
    version = "0.6.0";
    src = self.python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "0fqalkvl4nk66cah010ga5nx67df9p79dkqkamsvjc3vj1qxycf1";
    };
    checkInputs = with self.python3Packages; [
      check-manifest isort pydocstyle pytest pytestcov pytestpep8 pytestrunner mock
    ];
  };

  openshift-python-client = self.python3Packages.buildPythonPackage rec {
    pname = "openshift";
    version = "0.11.2";
    src = self.python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "1z3sq6gsg2kq10lgg6v5wrbm2q99xrnv42hmzpq00dd8hhy0s2qi";
    };
    doCheck = false;
    propagatedBuildInputs = with self.python3Packages ; [
      jinja2 kubernetes python-dictdiffer python-string-utils ruamel_yaml six
    ];
  };

  python-string-utils = self.python3Packages.buildPythonPackage rec {
    pname = "python-string-utils";
    version = "0.6.0";
    src = self.python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "07xgb1q6dgpw1vxdzzvq6v3y8kfw6lgxr4pr999rnqjbi26lmlh5";
    };
  };
}
