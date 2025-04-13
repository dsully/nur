{
  lib,
  pkgs,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "pkl-lsp";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "apple";
    repo = "pkl-lsp";
    rev = version;
    hash = "sha256-fB8HvA2jOI1xHWq3/XYyTQJTNn4ixY7fFvqw3FJI4Ac=";
  };

  buildInputs = [
    pkgs.kotlin
  ];

  meta = {
    description = "Language server for Pkl, implementing the server-side of the Language Server Protocol";
    homepage = "https://github.com/apple/pkl-lsp";
    license = lib.licenses.asl20;
    mainProgram = "pkl-lsp";
    platforms = lib.platforms.all;
  };
}
