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
      rev = "f620396123b5d4cbfb9d904d867d5e4ceb15e779";
      hash = "sha256-UGgOk61+b8f86oQpZtovG6vQ1lXrlH3Oovank3VXg0g=";
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
