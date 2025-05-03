{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  zstd,
}:
rustPlatform.buildRustPackage rec {
  pname = "sith-language-server";
  version = "b87963b3ca6da0a1678c5ebf71aac1fd49e964a4";

  src = fetchFromGitHub {
    owner = "LaBatata101";
    repo = "sith-language-server";
    rev = version;
    hash = "sha256-Bm5LL/CnA9KDzN+MQxFggenLEy1yDc/WxUveYesT2Qk=";
  };

  cargoHash = "sha256-RQ5xsWR58yUxjAZx2qnuw7MfpvHrifC9tEHhia5Sdps=";
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
    mainProgram = "sith-lsp";
  };
}
