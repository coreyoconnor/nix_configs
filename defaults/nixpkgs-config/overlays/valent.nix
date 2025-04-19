self: super: {
  valent = super.valent.overrideAttrs (oldAttrs: {
    src = self.fetchFromGitHub {
      repo = "valent";
      #owner = "coreyoconnor";
      # rev = "ef1945c69993e8614b1a8444461d72e13652aab6";
      # hash = "sha256-pgL8LzEp6+kKLDUPzkY1ehg+4N7zGSff7kThNcaCsw0=";
      owner = "andyholmes";
      rev = "08a2c3a67045dcf8892bca03f65658878fd297f6";
      hash = "sha256-/ai6PgFceG1BYTQIcUgy1zZaU5j3dubdH9NeiT3kj4Q=";
      fetchSubmodules = true;
    };
  });
}
