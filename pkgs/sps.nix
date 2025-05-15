{
  rustPlatform,
  lib,
  fetchFromGitHub,
  pkgs,
  stdenv,
}:
if stdenv.isDarwin
then
  rustPlatform.buildRustPackage {
    pname = "sps";
    version = "0.1.31";

    src = fetchFromGitHub {
      owner = "alexykn";
      repo = "sps";
      rev = "0e015e481c21307cc3509693168e14698376c32e";
      hash = "sha256-768aJMnDjPyDzztUK53MTCqqMVafhrqG/Bn2IyaxrFk=";
    };

    cargoHash = "sha256-w1gAXGxnx1cFHa8QO+Som983eQ31wvQwjFEHD9LqTcM=";
    useFetchCargoVendor = true;
    doCheck = false;

    nativeBuildInputs = [
      pkgs.pkg-config
    ];

    buildInputs = [
      pkgs.openssl
    ];

    meta = {
      description = "Rust based package manager for macOS";
      homepage = "https://github.com/alexykn/sps";
      license = lib.licenses.bsd3;
      mainProgram = "sps";
      platforms = lib.platforms.darwin;
    };
  }
else {}
