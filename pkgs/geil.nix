{
  lib,
  rustPlatform,
  fetchFromGitHub,
  ...
}: let
  pname = "geil";
in
  rustPlatform.buildRustPackage {
    inherit pname;
    version = "unstable-2025-03-01";

    src = fetchFromGitHub {
      owner = "Nukesor";
      repo = pname;
      rev = "6fb6bbe";
      hash = "sha256-CZW6XYuq2pTd2HMFuAj3G3fiiWrBAxjgUQdjnU7zz8c=";
    };

    cargoHash = "sha256-BwtaJ+mHJtN6yqlgK9e3tZzsY1IIQKsS4PFADSxDO9Q=";
    useFetchCargoVendor = true;
    doCheck = false;

    meta = {
      description = "Rocket: A tool to update your repositories and for keeping them clean";
      homepage = "https://github.com/Nukesor/geil";
      license = lib.licenses.mit;
      mainProgram = pname;
    };
  }
