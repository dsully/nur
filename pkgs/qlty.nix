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
    rev = "7b099c5070c87ce3d4296a07b7e8ab5199413907";
    hash = "sha256-UfiPMu+0vUCY+iEztH3nIHCdY4C8YWq7lhYCCiKZfgA=";
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
