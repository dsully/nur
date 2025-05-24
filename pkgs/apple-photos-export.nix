{
  fetchFromGitHub,
  lib,
  pkgs,
  rustPlatform,
  stdenv,
  ...
}:
if stdenv.isDarwin
then
  rustPlatform.buildRustPackage rec {
    pname = "apple-photos-export";
    version = "1.0.0";

    src = fetchFromGitHub {
      owner = "haukesomm";
      repo = "apple-photos-export";
      rev = "951c354984c8b05c46c87866e3a46267b7c6b391";
      hash = "sha256-ek2euDo61q9ICduJng3rSyB4cvJVSjTX9E2elk/3q6c=";
    };

    cargoHash = "sha256-bsPR/1y5dUnuC785H/p5A3hbFZ1oPiBtZNgx/vrszbs=";
    useFetchCargoVendor = true;
    doCheck = false;

    nativeBuildInputs = [
      pkgs.pkg-config
    ];

    buildInputs = [
      pkgs.sqlite
    ];

    meta = {
      description = "Command line tool to export photos from the macOS Photos library, organized by album and/or date";
      homepage = "https://github.com/haukesomm/apple-photos-export";
      changelog = "https://github.com/haukesomm/apple-photos-export/blob/${src.rev}/CHANGELOG.md";
      license = lib.licenses.mit;
      mainProgram = "apple-photos-export";
      platforms = lib.platforms.darwin;
    };
  }
else {}
