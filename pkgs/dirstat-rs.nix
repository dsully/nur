{
  lib,
  pkgs,
  fetchFromGitHub,
  rustPlatform,
  ...
}:
rustPlatform.buildRustPackage rec {
  pname = "dirstat-rs";
  version = "v0.3.7";

  src = fetchFromGitHub {
    owner = "scullionw";
    repo = pname;
    rev = "607c2b797078d71eac8a414fa04b46539f5323d1";
    sha256 = "sha256-gDIUYhc+GWbQsn5DihnBJdOJ45zdwm24J2ZD2jEwGyE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-SdxTiIrsK3U4mcrcilOhMkkp12yEUkWlXmlT+C75dZw=";

  meta = with lib; {
    description = "Fast, cross-platform disk usage CLI";
    homepage = "https://github.com/scullionw/dirstat-rs";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [lanice];
  };
}
