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
    version = "2025-05-01-255e633";

    src = fetchFromGitHub {
      owner = "alexykn";
      repo = "sps";
      rev = "2c5d5152471d61b08012c8dcdea3e93725032f3c";
      hash = "sha256-X5LzIHlLGKwQwMxiCIWHqU8JLEwnkCqDANhZclBqxPE=";
    };

    cargoHash = "sha256-eOlA3Mdh/FNLPF3AjlKmOrIxZJGQFFWaH/6MBZ6k3Zs=";
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
