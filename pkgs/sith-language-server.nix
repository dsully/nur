{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  zstd,
}:
rustPlatform.buildRustPackage rec {
  pname = "sith-language-server";
  version = "HEAD";

  src = fetchFromGitHub {
    owner = "LaBatata101";
    repo = "sith-language-server";
    rev = version;
    hash = "sha256-7y/kw58nRwCY2NUBGub2wxI6e4NoBSPuNWqekQYVHxw=";
  };

  cargoHash = "sha256-Bf+Oz5HV1BhbCMqRSMgjUcF/oYjuDh+GkU6PPOIZmhw=";
  useFetchCargoVendor = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    zstd
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  meta = {
    description = "An experimental Python language server made in Rust";
    homepage = "https://github.com/LaBatata101/sith-language-server";
    license = lib.licenses.mit;
    mainProgram = "sith-language-server";
  };
}
