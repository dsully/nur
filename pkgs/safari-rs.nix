{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  zlib,
  stdenv,
  darwin,
}:
rustPlatform.buildRustPackage rec {
  pname = "safari-rs";
  version = "HEAD";

  src = fetchFromGitHub {
    owner = "dsully";
    repo = "safari.rs";
    rev = "9f70ad53f7c6b27c3fb8ec9e19ce96c1c8754bb6";
    hash = "sha256-ke8F+FIvREyKWulA7tfiR6rTVZNhBsczwNf7qdfZ7fA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-NfeodLNm5XBIwt4GKmWg8kVCc6/LTyhLy8dCS6iJMr0=";
  doCheck = false;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      openssl
      zlib
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.Security
    ];

  meta = {
    description = "Command-line utilities for interacting with Safari on macOS";
    homepage = "https://github.com/dsully/safari.rs";
    changelog = "https://github.com/dsully/safari.rs/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = pname;
  };
}
