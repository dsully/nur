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
    hash = "sha256-b9b0rgpTr8wXTCOcUhv8a1U++ebBWMaeiuIArv4m0PI=";
  };

  cargoHash = "sha256-iukhQf4JfNLrNbuv9A6W+A6v9TDunfDzb3eEiI+l29U=";
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
