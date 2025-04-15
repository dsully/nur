/*
  This contains various packages we want to overlay. Note that the
* other ".nix" files in this directory are automatically loaded.
*/
prev: {lib, ...}: let
  # Function to import a single file
  importPackage = file: prev.callPackage file {};

  # Get all .nix files from the packages directory
  packageFiles =
    lib.filterAttrs
    (name: type: type == "regular" && lib.hasSuffix ".nix" name)
    (builtins.readDir ../pkgs);

  # Convert filenames to attribute names (remove .nix extension)
  packageAttrs =
    lib.mapAttrs'
    (
      name: _:
        lib.nameValuePair
        (lib.removeSuffix ".nix" name)
        (importPackage ../pkgs/${name})
    )
    packageFiles;

  # Handle special cases: directories
  specialCases = {
    reading-list-to-pinboard-rs = prev.callPackage ../pkgs/reading-list-to-pinboard-rs {};
  };
in
  specialCases // packageAttrs
