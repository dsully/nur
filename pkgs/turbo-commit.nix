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
  pname = "turbo-commit";
  version = "5a4075e";

  src = fetchFromGitHub {
    owner = "dikkadev";
    repo = "turboCommit";
    rev = version;
    hash = "sha256-UAgEoziYzAdF3E+0i6BFEDsg+ZS+h6AGulldI58qcmI=";
  };

  cargoHash = "sha256-jScu7Fjz4qfmQ7b7/UGoMkYFNg7Bwc7beC5z/L0b5jU=";
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
    description = "Turbocommit is a Rust-based CLI tool that generates high-quality git commit messages in accordance with the Conventional Commits specification, using OpenAI API compatible service. It is easy to use and a cost-effective way to keep git commit history at a higher quality, helping developers stay on track with their work";
    homepage = "https://github.com/dikkadev/turboCommit";
    license = lib.licenses.mit;
    mainProgram = "turbo-commit";
  };
}
