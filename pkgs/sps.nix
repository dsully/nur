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
    version = "0.1.44";

    src = fetchFromGitHub {
      owner = "alexykn";
      repo = "sps";
      rev = "9b85d4511df724b98f09f5bd846a4b2c508fdbac";
      hash = "sha256-iPhKRn/EJibZ6VbJ/Yi0iheOHswjgoc0q4daZMYeG6g=";
    };

    cargoHash = "sha256-aAPZphtQCZF74VFb2KrgCcBYF3MoRYelKou34jvHuTA=";
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
