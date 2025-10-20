# Project Overview

This repository contains a Nix flake library for managing NixOS configurations. It provides a structured framework for defining multiple systems and deploying them using `deploy-rs`. The library is designed to be used as a flake input in a user's own Nix configuration repository.

The core of the library is the `mkFlake` function, which takes a configuration object and generates the necessary `nixosConfigurations`, `deploy` nodes, and a development shell. The library also provides a set of default configurations for all systems, including Nix settings, `nix-index`, and user authentication.

## Building and Running

Use `nix build .#devShells.x86_64-linux.default` to build the development shell. Check `./result/bin` for the
expected commands.

## Development Conventions

*   **Formatting:** The project uses `alejandra` to format Nix code. The formatter can be run with `nix fmt`.
*   **Development Shell:** The development shell is configured using `devshell`.  Use `nix develop` to enter
the development shell.
*   **Structure:** The project is structured as a Nix flake library. The main logic is in the `lib` directory, and default configurations are in the `defaults` directory. The `modules` directory is currently empty, but can be used to add custom modules.
