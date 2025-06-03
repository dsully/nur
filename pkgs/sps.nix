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
    version = "0.1.56";

    src = fetchFromGitHub {
      owner = "alexykn";
      repo = "sps";
      rev = "45b3d2a20e6c07ce23e3355639af16939777ba8c";
      hash = "sha256-KG+7fWuCTW9u5AdD2YdJetbQStr1/Uj/8WIjTOEKT4E=";
    };

    cargoHash = "sha256-Yn6N9drCaGjY/Z/C0jRxX9H3+BriOZhEO3klSd3EDMs=";
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
