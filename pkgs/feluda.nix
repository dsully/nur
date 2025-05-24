{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkgs,
  ...
}:
rustPlatform.buildRustPackage rec {
  pname = "feluda";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "anistark";
    repo = "feluda";
    rev = version;
    hash = "sha256-R8x4lN4BtVbpSHll0KVdzX7IDhArsZiJFo6qNsFrgnA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-F5flqmoH9QykmCvuqxLhsdpm3AYhwhCG4O1oRkEOY8U=";
  doCheck = false;

  nativeBuildInputs = [
    pkgs.pkg-config
  ];

  buildInputs = [
    pkgs.openssl
  ];

  meta = {
    description = "Detect license usage restrictions in your project";
    homepage = "https://github.com/anistark/feluda";
    license = lib.licenses.mit;
    mainProgram = "feluda";
  };
}
