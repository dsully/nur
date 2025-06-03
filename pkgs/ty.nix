{
  buildPackages,
  fetchFromGitHub,
  installShellFiles,
  lib,
  nix-update-script,
  rustPlatform,
  stdenv,
  ...
}:
rustPlatform.buildRustPackage rec {
  pname = "ty";
  version = "0.0.1-alpha.8";

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "ruff";
    rev = "8d98c601d8fb0c7fafe503c6fa22427357eb5080";
    hash = "sha256-GEjsZdWsRrNyEx0tPko6ULvzapDYGpHWcf2VueWzW3Y=";
  };

  cargoBuildFlags = ["--package=ty"];
  cargoHash = "sha256-XISRy7Ncy0lTlsCFYmJBcgGiDJfdygTDF4f9O9ZlzDU=";

  doCheck = false;
  nativeBuildInputs = [installShellFiles];
  useFetchCargoVendor = true;

  postInstall = lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in ''
      installShellCompletion --cmd ty \
        --bash <(${emulator} $out/bin/ty generate-shell-completion bash) \
        --fish <(${emulator} $out/bin/ty generate-shell-completion fish) \
        --zsh <(${emulator} $out/bin/ty generate-shell-completion zsh)
    ''
  );

  passthru = {
    updateScript = nix-update-script {extraArgs = ["--version=unstable"];};
  };

  meta = {
    description = "Extremely fast Python type checker and language server, written in Rust";
    homepage = "https://github.com/astral-sh/ruff";
    changelog = "https://github.com/astral-sh/ty/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "ty";
  };
}
