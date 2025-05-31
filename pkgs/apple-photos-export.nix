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
      rev = "9a7634c14b3ea12f410dc912d55afcd6db831bea";
      hash = "sha256-bkdf91H9kPwEN3cU8e65XQT9/PhO4kpP1lqOLv6E63Y=";
    };

    cargoHash = "sha256-1oqtnfqMSYTjCuAF/PNJ6I4LbfxzksGoSVmnCWNcMiQ=";
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
