{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  zlib,
}:
rustPlatform.buildRustPackage rec {
  pname = "devmoji-log";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "dsully";
    repo = "devmoji-log";
    rev = "v${version}";
    hash = "sha256-xUZOlUTPRdBlbnsiJkDsLlM/FHoqxV3jWxwkfkbwDIc=";
  };

  cargoHash = "sha256-6ETHadkmTqnO+/bpXn2KhrnKkf0ezyDJP51bid7wT2U=";
  useFetchCargoVendor = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    zlib
  ];

  meta = {
    description = "Display Git commit history with conventional commit types and gitmojis";
    homepage = "https://github.com/dsully/devmoji-log";
    license = lib.licenses.mit;
    maintainers = ["dsully"];
    mainProgram = "devmoji-log";
  };
}
