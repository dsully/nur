{
  lib,
  stdenv,
  fetchFromGitHub,
  zig,
  ...
}:
stdenv.mkDerivation {
  pname = "ghostty-ls";
  version = "unstable-2025-03-11";

  src = fetchFromGitHub {
    owner = "MKindberg";
    repo = "ghostty-ls";
    rev = "b7714f05afdc9459b080c6a6e1bebe80153b5d5a";
    hash = "sha256-GQpepTgqpVOjiby7WhztJEGv6o2WYLkkJCqBkxuu7XM=";
  };

  nativeBuildInputs = [
    zig.hook
  ];

  meta = {
    description = "A language server for working with the ghostty config";
    homepage = "https://github.com/MKindberg/ghostty-ls";
    license = lib.licenses.mit;
    mainProgram = "ghostty-ls";
    inherit (zig.meta) platforms;
  };
}
