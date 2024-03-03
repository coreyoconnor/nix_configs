Custom installer image.

The link farm result of:
```
nix build
```

will include a link to the `isoImage`.

Likewise:

```
dev-build nixos-installer-x86-image
prod-build nixos-installer-x86-image
```

The code treats the "-image" as a flag indicating the `nix build` link farm should contain a link to the
`isoImage` - not the system result.
