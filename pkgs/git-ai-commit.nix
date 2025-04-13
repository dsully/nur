{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  zlib,
  stdenv,
  darwin,
}:
rustPlatform.buildRustPackage rec {
  pname = "git-ai-commit";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "ince01";
    repo = "git-ai-commit";
    rev = "v${version}";
    hash = "sha256-BNNPaDSLRwhz1jJMck08inj0YdwOex7T3ccxGQZMGJg=";
  };

  cargoHash = "sha256-LwZnBCglMVOhaZ7kslsnZEFZAXJWoGreD64OmLfTgBM=";
  useFetchCargoVendor = true;
  doCheck = false;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      libgit2
      openssl
      zlib
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.Security
    ];

  meta = {
    description = "Smarter commits, crafted by AI & powered by Rust’s speed";
    homepage = "https://github.com/ince01/git-ai-commit";
    mainProgram = "git-ai-commit";
  };
}
