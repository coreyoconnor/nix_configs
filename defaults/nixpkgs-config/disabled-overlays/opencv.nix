self: super: {
  # https://github.com/NixOS/nixpkgs/issues/121050
  opencv4 = super.opencv4.override {
    enableCuda = false;
  };
  opencv3 = super.opencv3.override {
    enableCuda = false;
  };
}
