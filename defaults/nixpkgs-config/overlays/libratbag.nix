self: super: {
  libratbag = super.libratbag.overrideAttrs (oldAttrs: {
    src = self.fetchFromGitHub {
      owner  = "libratbag";
      repo   = "libratbag";
      rev    = "78d1124c3e7b992470017ab8a5b5af009745fe4f";
      hash   = "sha256-+aCORAue2hs8DPcWPszzMwGC9SMfJ/A0zpn7tCwuD9Y=";
    };
  });
}

