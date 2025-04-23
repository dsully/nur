{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "autorebase";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "Timmmm";
    repo = "autorebase";
    rev = version;
    hash = "sha256-KyusrY+LPLstQ65XqXIjBDJiLeuL7cuzN4uwCmtK8Ho=";
  };

  doCheck = false;

  cargoHash = "sha256-zeB+4RZRIRI6ZifE/xBoOps27s+1nmmB7gbc6KxfZWI=";
  useFetchCargoVendor = true;

  meta = {
    description = "Automatically rebase all your branches onto master";
    homepage = "https://github.com/Timmmm/autorebase";
    # license = lib.licenses.unfree;
    mainProgram = "autorebase";
  };
}
