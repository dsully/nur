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
    version = "0.1.41";

    src = fetchFromGitHub {
      owner = "alexykn";
      repo = "sps";
      rev = "ee9848110c00e01148a9ef58e9746f2919083aee";
      hash = "sha256-bCt89dwy8vUQF+hkvuX7/7sQWMfAQbEbGVjYCHXA6lg=";
    };

    cargoHash = "sha256-JftKB7YA3ENwo2AftOgMoc0T91gPRZARY/CK9vTKScE=";
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
