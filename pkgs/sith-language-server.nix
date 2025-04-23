{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  zstd,
}:
rustPlatform.buildRustPackage rec {
  pname = "sith-language-server";
  version = "05f9241";

  src = fetchFromGitHub {
    owner = "LaBatata101";
    repo = "sith-language-server";
    rev = version;
    hash = "sha256-eHvAPWhMKz2fk4p7a4y0Hz55U2Ax1ceS5IIt6MBXwBA=";
  };

  cargoHash = "sha256-4/hlS1oqQ8ConN8Rs1ldTTrWLehYMxjFj9rv4iIwxQE=";
  useFetchCargoVendor = true;
  doCheck = false;

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
