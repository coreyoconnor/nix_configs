self: super: {
  valent = super.valent.overrideAttrs (oldAttrs: {
    src = self.fetchFromGitHub {
      owner = "coreyoconnor";
      repo = "valent";
      rev = "ef1945c69993e8614b1a8444461d72e13652aab6";
      hash = "sha256-pgL8LzEp6+kKLDUPzkY1ehg+4N7zGSff7kThNcaCsw0=";
      fetchSubmodules = true;
    };
  });
}
