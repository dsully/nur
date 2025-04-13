{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  sqlite,
}:
rustPlatform.buildRustPackage rec {
  pname = "apple-photos-export";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "haukesomm";
    repo = "apple-photos-export";
    rev = "release-${version}";
    hash = "sha256-0kvEVtmY0P57dS62deS9EnO9H3NkjaYWFg2zZUGJRQU=";
  };

  cargoHash = "sha256-ZellOJYqCbyoPQFUeCiRmW6dES7Ke0A7G9pDdcXbuLA=";
  useFetchCargoVendor = true;
  doCheck = false;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    sqlite
  ];

  meta = {
    description = "Command line tool to export photos from the macOS Photos library, organized by album and/or date";
    homepage = "https://github.com/haukesomm/apple-photos-export";
    changelog = "https://github.com/haukesomm/apple-photos-export/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "apple-photos-export";
  };
}
