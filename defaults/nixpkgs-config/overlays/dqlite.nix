self: super: {
  dqlite = super.dqlite.overrideAttrs (prior: {
    patches = (prior.patches or []) ++ [
      (super.fetchpatch {
        url = "https://github.com/canonical/dqlite/commit/be453628ce782167f6652c055e600908e2641da7.patch?full_index=1";
        hash = "sha256-5DvZ1TW6QmE/heh/RjV395gSgwKM5XnqxqznfYQPC/Y=";
      })
    ];
    buildInputs = (prior.buildInputs or []) ++ [
      super.lz4
    ];
  });
}
