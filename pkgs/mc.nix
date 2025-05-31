{
  lib,
  rustPlatform,
  fetchFromGitHub,
  ...
}:
rustPlatform.buildRustPackage rec {
  pname = "mc";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "thewh1teagle";
    repo = pname;
    rev = "98b3951ed7eab4f72b2373666f1652cb79d6ccb4";
    hash = "sha256-MwfxMLLsZROu6UlsYCE5HfCRsZX66CnFhy4pO5+7W3E=";
  };

  cargoHash = "";
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
