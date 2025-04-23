{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  protobuf,
  bzip2,
  libgit2,
  oniguruma,
  openssl,
  zlib,
  zstd,
  stdenv,
  darwin,
}:
rustPlatform.buildRustPackage rec {
  pname = "qlty";
  version = "0.499.0";

  src = fetchFromGitHub {
    owner = "qltysh";
    repo = "qlty";
    rev = "v${version}";
    hash = "sha256-o4dw86gAP51hGB6pvy4C9VBqUHm6WG7nXOTMT9zU3LY=";
  };

  doCheck = false;
  cargoHash = "sha256-Jht6qgwmgZ7h4MtGp72KaZDox0adw9EAttn9bk3jO+Y=";
  useFetchCargoVendor = true;

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  buildInputs =
    [
      bzip2
      libgit2
      oniguruma
      openssl
      zlib
      zstd
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.CoreFoundation
      darwin.apple_sdk.frameworks.CoreServices
      darwin.apple_sdk.frameworks.IOKit
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  env = {
    OPENSSL_NO_VENDOR = true;
    RUSTONIG_SYSTEM_LIBONIG = true;
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  meta = {
    description = "Universal code quality CLI: Linting, formatting, security scanning, and metrics";
    homepage = "https://github.com/qltysh/qlty";
    changelog = "https://github.com/qltysh/qlty/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.bsl11;
    mainProgram = "qlty";
  };
}
