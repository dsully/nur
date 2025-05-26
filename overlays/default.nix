/*
  This contains various packages we want to overlay. Note that the
* other ".nix" files in this directory are automatically loaded.
*/
inputs: _: prev: let
  inherit (prev) lib;

  dirContents = builtins.readDir ../pkgs;

  packages = lib.pipe dirContents [
    (lib.filterAttrs (n: t: t == "regular" && lib.hasSuffix ".nix" n || t == "directory"))
    (lib.mapAttrs (
      name: _type:
        prev.callPackage ../pkgs/${name} {
          inherit inputs;
        }
    ))
    (lib.mapAttrs' (
      name: value:
        lib.nameValuePair (lib.removeSuffix ".nix" name) value
    ))
  ];
in
  packages
