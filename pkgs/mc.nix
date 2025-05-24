{
  lib,
  rustPlatform,
  fetchFromGitHub,
  ...
}: let
  pname = "mc";
in
  rustPlatform.buildRustPackage rec {
    inherit pname;
    version = "0.4.3";

    src = fetchFromGitHub {
      owner = "thewh1teagle";
      repo = pname;
      rev = "v${version}";
      hash = "sha256-tzazDKwbSLjP/rc2jHjBiNQVgvNJnTGjcZPAz6Fx7PA=";
    };

    cargoHash = "sha256-ckpymHty1Aq79l19p/wz+ywdaU+Corr0Fnm+ZQ80+EE=";
    useFetchCargoVendor = true;
    doCheck = false;

    nativeBuildInputs = [
      rustPlatform.bindgenHook
    ];

    meta = {
      description = "Modern file copying";
      homepage = "https://github.com/thewh1teagle/mc";
      license = lib.licenses.unfree;
      mainProgram = pname;
    };
  }
