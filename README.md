# Yo

Library for managing computers using

- Uses https://github.com/serokell/deploy-rs/tree/master

plus helpful tools.

I use this to manage my computers. See:

- https://github.com/coreyoconnor/home-hive/blob/main/flake.nix

## Using

For the `flake.nix`:

```nix
{
  description = "";

  inputs = {
    nixpkgs.url = "github:coreyoconnor/nixpkgs/main";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/master";

    nix_configs = {
      url = "github:coreyoconnor/nix_configs/dev-lib";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-unstable.follows = "nixpkgs-unstable";
      };
    };
  };

  outputs = { self, nix_configs, ... }@inputs:
    nix_configs.lib.mkFlake inputs {
      systems = {
        my-computer = { system = "x86_64-linux"; };
      };
    };
  };
}

```

And a `computers/my-computer/default.nix`

```nix
{
  config,
  pkgs,
  nixpkgs,
  lib,
  ...
}: {
  # default module code here
}
```

Will provide a dev shell (use `nix develop`) with:

```
[devshell]$ menu

[[general commands]]

  deploy-rs                    - Multi-profile Nix-flake deploy tool
  dev-apply                    - apply using the dev input overrides and git submodules
  dev-boot                     - boot using the dev input overrides and git submodules
  dev-build                    - Build using the dev input overrides and git submodules
  dev-build-vm                 - build vm launcher
  dev-dry-run                  - dry-run using the dev input overrides and git submodules
  dev-fetch
  dev-nix-build
  dev-status
  menu                         - prints this menu
  prod-apply                   - apply using the production inputs
  prod-boot                    - boot using the production inputs
  prod-build
  prod-dry-run                 - dry-run using the production inputs
  prod-status

```

Where `prod-build my-computer` would build the "production" (uses flake inputs) configuration for
`my-computer`.

The `dev-` commands do not use the `flake.lock` like the `prod-` commands. Instead these use a submodule
checkout under `dev/`. Which is useful to iterate on a flake dependency using submodules. While keeping the
`prod-` builds clean of those changes.

## Default Configuration

This applies a default configuration to all `computers/` defined in `systems`:

1. the nix flake registry is the flake used to build the computer
2. hostname is the computer name
3. nix regularly GCs
4. `wheel` users are authorized to `journal`

### 1. Configured Registry

This ensures when using `nix shell nixpkgs#foo` the `nixpkgs` being referred to is *exactly* the `nixpkgs`
used to build the computer. This is typically what I want: Consistency between the two.

Add a `nixpkgs-unstable` import to your `flake.nix` and `nix flake update nixpkgs-unstable`. This provides an
`nixpkgs-unstable` registry entry that is relatively easy to update.

## Development

enter the development shell with:

```
nix develop
```


