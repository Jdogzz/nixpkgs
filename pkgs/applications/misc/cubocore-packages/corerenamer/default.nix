{
  mkDerivation,
  lib,
  fetchFromGitLab,
  qtbase,
  cmake,
  ninja,
  libcprime,
  libcsys,
}:

mkDerivation rec {
  pname = "corerenamer";
  version = "4.5.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-jN1keyo2tDlgUu243173zgChw2nhvbsLPH9af6jDhKs=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qtbase
    libcprime
    libcsys
  ];

  meta = with lib; {
    description = "Batch file renamer from the C Suite";
    mainProgram = "corerenamer";
    homepage = "https://gitlab.com/cubocore/coreapps/corerenamer";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dan4ik605743 ];
    platforms = platforms.linux;
  };
}
