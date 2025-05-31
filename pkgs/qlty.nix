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
  ...
}:
rustPlatform.buildRustPackage rec {
  pname = "qlty";
  version = "0.499.0";

  src = fetchFromGitHub {
    owner = "qltysh";
    repo = "qlty";
    rev = "8c93f9b7691b3128c48bb036d7ddd5124ea901f0";
    hash = "sha256-VzpeVZ6wpfLSuQC5KVScEZK8C4dOIFeYNQfw/q20bIE=";
  };

  doCheck = false;
  cargoHash = "";
  useFetchCargoVendor = true;

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  buildInputs = [
    bzip2
    libgit2
    oniguruma
    openssl
    zlib
    zstd
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
