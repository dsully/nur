{
  lib,
  stdenv,
  fetchurl,
  jdk23_headless,
  makeWrapper,
}:
stdenv.mkDerivation rec {
  pname = "pkl-lsp";
  version = "0.2.0";

  meta = {
    description = "Language server for Pkl, implementing the server-side of the Language Server Protocol";
    homepage = "https://github.com/apple/pkl-lsp";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };

  src = fetchurl {
    url = "https://github.com/apple/pkl-lsp/releases/download/${version}/${pname}-${version}.jar";
    sha256 = "sha256-5f4be3ba0ccd485dcb509024bbfb1490d5ab8dc642354c30b93bfaab70e6b1e9";
  };

  nativeBuildInputs = [makeWrapper];
  buildInputs = [jdk23_headless];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/java $out/bin
    cp $src $out/share/java/${pname}-${version}.jar

    makeWrapper ${jdk23_headless}/bin/java $out/bin/${pname} \
      --add-flags "-jar $out/share/java/${pname}-${version}.jar"
  '';
}
