{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage rec {
  pname = "curlconverter";
  version = "4.12.0";

  src = fetchFromGitHub {
    owner = "curlconverter";
    repo = "curlconverter";
    rev = "v${version}";
    hash = "sha256-eJ8D5HkYSkWqQt/4UTv6/X6coLwcODde6xGEPQXgJRo=";
  };

  npmDepsHash = "sha256-UIbMvw8hkZxtSGInV2+Fjm4DZahrdGtSxi0Unhb5lh8=";
  NODE_OPTIONS = "--openssl-legacy-provider";

  meta = {
    description = "Transpile curl commands into Python, JavaScript and 27 other languages";
    homepage = "https://github.com/curlconverter/curlconverter";
    license = lib.licenses.mit;
    mainProgram = "curlconverter";
    platforms = lib.platforms.all;
  };
}
