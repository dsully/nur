{
  rustPlatform,
  lib,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage {
  pname = "oli";
  version = "2025-05-11-30c2af6";

  src = fetchFromGitHub {
    owner = "amrit110";
    repo = "oli";
    rev = "30c2af6adf950abc446e4b23cce8c8847c76a95e";
    hash = "sha256-0bRkvHzXZ9mUXZJG+Ekt1XZmD8BTTr7yBJdxAS3OmKA=";
  };

  cargoHash = "sha256-aNdG3olJxgA1YvK+MXPlI66wvWTOuIgGJWjV1kGWuTQ=";
  useFetchCargoVendor = true;
  doCheck = false;

  meta = {
    description = "A simple, fast terminal based AI coding assistant";
    homepage = "https://github.com/amrit110/oli";
    license = lib.licenses.asl20;
    mainProgram = "oli";
  };
}
