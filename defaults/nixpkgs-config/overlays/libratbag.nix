self: super: {
  libratbag = super.libratbag.overrideAttrs (oldAttrs: {
    src = self. fetchFromGitHub {
      owner  = "libratbag";
      repo   = "libratbag";
      rev    = "1c9662043f4a11af26537e394bbd90e38994066a";
      hash   = "sha256-IpN97PPn9p1y+cAh9qJAi5f4zzOlm6bjCxRrUTSXNqM=";
    };
  });
}

