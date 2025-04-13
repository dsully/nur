{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:
rustPlatform.buildRustPackage rec {
  pname = "feluda";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "anistark";
    repo = "feluda";
    rev = version;
    hash = "sha256-UajBNdyqLi5XALS4JdQa5B+Trwx5298rSzIvD3mZ5xQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-NJJblqpxOxVsE0Qbg258eLhNATDn8r6jjqtg7Q3Gb/8=";
  doCheck = false;

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = {
    description = "Detect license usage restrictions in your project";
    homepage = "https://github.com/anistark/feluda";
    license = lib.licenses.mit;
    mainProgram = "feluda";
  };
}
