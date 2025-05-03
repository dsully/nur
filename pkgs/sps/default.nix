{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkgs,
  stdenv,
}:
lib.optionalAttrs stdenv.isDarwin (
  rustPlatform.buildRustPackage rec {
    pname = "sps";
    version = "2025-05-01-255e633";

    src = fetchFromGitHub {
      owner = "alexykn";
      repo = "sps";
      rev = "255e633f1506689d1b176ab4a8d60b928096dc03";
      hash = "sha256-vd0KCGM7tOpYe0L4DukIIx6/RKzM3JsJzIj2FIizSeg=";
    };

    cargoLock = {
      lockFile = ./Cargo.lock;
      allowBuiltinFetchGit = true;
    };

    postPatch = ''
      ln -s ${./Cargo.lock} Cargo.lock
    '';

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
      maintainers = with lib.maintainers; [];
      license = lib.licenses.bsd3;
      mainProgram = "sps";
      platforms = lib.platforms.darwin;
    };
  }
)
