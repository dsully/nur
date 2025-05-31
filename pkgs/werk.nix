{
  lib,
  rustPlatform,
  fetchFromGitHub,
  ...
}:
rustPlatform.buildRustPackage rec {
  pname = "werk";
  version = "unstable-2025-02-25";

  src = fetchFromGitHub {
    owner = "simonask";
    repo = pname;
    rev = "48b4b2698602ccc6ab575e01401d0c535fc7d40e";
    hash = "sha256-sKOTyyBCRKYV4ASYX6b2jMJJPdhdJlU5065bUUt+ugk=";
  };

  cargoHash = "sha256-MwVM/CaEdYoCBmizYSgMhHnWBlenyvS1/dgu948Pzrc=";
  useFetchCargoVendor = true;
  doCheck = false;

  meta = {
    description = "Simplistic command runner and build system";
    homepage = "https://github.com/simonask/werk";
    license = with lib.licenses; [asl20 mit];
    mainProgram = pname;
  };
}
