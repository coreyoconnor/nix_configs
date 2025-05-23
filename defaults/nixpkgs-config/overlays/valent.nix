self: super: {
  valent = super.valent.overrideAttrs (oldAttrs: {
    src = self.fetchFromGitHub {
      repo = "valent";
      #owner = "coreyoconnor";
      # rev = "ef1945c69993e8614b1a8444461d72e13652aab6";
      # hash = "sha256-pgL8LzEp6+kKLDUPzkY1ehg+4N7zGSff7kThNcaCsw0=";
      owner = "andyholmes";
      rev = "b52578531f58f72fde4de41a79e56578183353c5";
      hash = "sha256-kv5Wanbw82kgikD4K22Ffq/qH68ENCCdyGJ5nFjn6ak=";
      fetchSubmodules = true;
    };
  });
}
