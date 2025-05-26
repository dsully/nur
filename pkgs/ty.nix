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
  version = "0.0.1-alpha.7";

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "ruff";
    rev = "62ef96f";
    hash = "sha256-X+w8qxbnLMW9OekTojK5At/gP5VTF5UBuxElJAT7ajI=";
  };

  cargoBuildFlags = ["--package=ty"];
  cargoHash = "sha256-pYv99huRgqcFcnkMkfFoejmZmVkb9q/VVlYfylPXo4o=";

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
    homepage = "https://github.com/astral-sh/ty";
    changelog = "https://github.com/astral-sh/ty/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "ty";
  };
}
