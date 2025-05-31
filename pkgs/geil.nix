{
  lib,
  rustPlatform,
  fetchFromGitHub,
  ...
}:
rustPlatform.buildRustPackage {
  pname = "geil";
  version = "0.0.1-alpha.0";

  src = fetchFromGitHub {
    owner = "Nukesor";
    repo = "geil";
    rev = "5d77a186681bd697d7f77b34a14c553b521a88e2";
    hash = "sha256-Jlb8B8XZUSkhzDW2+fBrYl9+7fxbd8fanfEhmb/hjcM=";
  };

  cargoHash = "sha256-6wXlj+Z9OhQGJfhzfwe8wYw0x2enMWr1xgRShv0ZDKw=";
  useFetchCargoVendor = true;
  doCheck = false;

  meta = {
    description = "Rocket: A tool to update your repositories and for keeping them clean";
    homepage = "https://github.com/Nukesor/geil";
    license = lib.licenses.mit;
    mainProgram = "geil";
  };
}
