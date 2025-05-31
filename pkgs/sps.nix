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
    version = "0.1.55.1";

    src = fetchFromGitHub {
      owner = "alexykn";
      repo = "sps";
      rev = "aa1b4feac8cc60726b512d103f73b56b031d0302";
      hash = "sha256-DWRyhG363wNxtN6ezCEdp5eSSK+mECuQVdnUNKJ0Sdc=";
    };

    cargoHash = "sha256-fM2ckEODEdPQTVfwjpZz/3KckeexGZXHN2vUjtuI2Ag=";
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
