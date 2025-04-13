{
  lib,
  rustPlatform,
  fetchFromGitHub,
}: let
  pname = "magic-opener";
  version = "0.0.5";
in
  rustPlatform.buildRustPackage rec {
    inherit pname;
    inherit version;

    src = fetchFromGitHub {
      owner = "dsully";
      repo = pname;
      rev = version;
    };

    useFetchCargoVendor = true;

    meta = {
      description = "A tool for opening the right thing in the right place";
      homepage = "https://github.com/dsully/magic-opener";
      license = lib.licenses.mit;
      mainProgram = "open";
    };
  }
