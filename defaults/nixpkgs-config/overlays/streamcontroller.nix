self: super: {
  streamcontroller = super.streamcontroller.overrideAttrs (oldAttrs: {

    src = self.fetchFromGitHub {
      repo = "StreamController";
      owner = "StreamController";
      rev = "45f35cb083c6ac3ef6c2f3943f65308f769b5530";
      hash = "sha256-Sn6/6lgAccLH+zomOpNb50gfDUsfrLHVFlgVdHd1kEs=";
    };
  });
}
