{
  rustPlatform,
  lib,
  fetchFromGitHub,
  pkgs,
  stdenv,
  ...
}:
if stdenv.isDarwin
then
  rustPlatform.buildRustPackage {
    pname = "sps";
    version = "0.1.55";

    src = fetchFromGitHub {
      owner = "alexykn";
      repo = "sps";
      rev = "4132ae788391010ae688d5aa00577f6152120a7d";
      hash = "sha256-MqxrFgoKsQe8n7IE7/CBESVNoe5je7teAT+9SzO9gJ0=";
    };

    cargoHash = "sha256-DzCl7xe6ZvOZ1InVP78hePdY2CJPxqxQC3um/u6lb9Q=";
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
