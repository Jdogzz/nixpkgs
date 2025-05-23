{
  mkDerivation,
  lib,
  fetchFromGitLab,
  libarchive,
  xz,
  zlib,
  bzip2,
  meson,
  pkg-config,
  ninja,
}:

mkDerivation rec {
  pname = "libarchive-qt";
  version = "2.0.8";

  src = fetchFromGitLab {
    owner = "marcusbritanicus";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-31a6DsxObSJWyLfT6mVtyjloT26IwFHpH53iuyC2mco=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libarchive
    bzip2
    zlib
    xz
  ];

  meta = with lib; {
    description = "Qt based archiving solution with libarchive backend";
    mainProgram = "archiver";
    homepage = "https://gitlab.com/marcusbritanicus/libarchive-qt";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}
