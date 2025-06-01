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
    rev = "54f597658ce986b140598fa7db65b99335f90cdf";
    hash = "sha256-PhlkE1ZBi4YUxzKOk6dso1byElRv03GFfV9Re7uvj5c=";
  };

  cargoBuildFlags = ["--package=ty"];
  cargoHash = "sha256-N+3JvTWSHYlVKrqz5Q4hFiMCVSSLm8olP0l0ClmKqEQ=";

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
