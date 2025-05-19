{
  fetchFromGitHub,
  lib,
  pkgs,
  rustPlatform,
}:
rustPlatform.buildRustPackage {
  pname = "oli";
  version = "2025-05-11-30c2af6";

  src = fetchFromGitHub {
    owner = "amrit110";
    repo = "oli";
    rev = "7aff185dc42091633dd63da142c5deaa4b7996db";
    hash = "sha256-mhGdv577EzkQ2Z44iR+qsIBLYn9mhTWS8HL5ZUqZFB4=";
  };

  cargoHash = "sha256-KP0rmrU+RUmyK1HGf/QMI8ZJpL/1WTaEu737q9dx0Rc=";
  useFetchCargoVendor = true;
  doCheck = false;

  nativeBuildInputs = [
    pkgs.pkg-config
  ];

  buildInputs = [
    pkgs.openssl
  ];

  meta = {
    description = "A simple, fast terminal based AI coding assistant";
    homepage = "https://github.com/amrit110/oli";
    license = lib.licenses.asl20;
    mainProgram = "oli";
  };
}
