{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  SDL2,
  libGLU,
  libGL,
  zlib,
  libjpeg,
  libogg,
  libvorbis,
  openal,
  curl,
  copyDesktopItems,
  makeDesktopItem,
}:

stdenv.mkDerivation rec {
  pname = "dhewm3";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "dhewm";
    repo = "dhewm3";
    tag = version;
    sha256 = "sha256-losqnxnjRPOczjrRPyyOxCeg9TNScXLcXADgo9Bxm5k=";
  };

  # Add libGLU libGL linking
  patchPhase = ''
    sed -i 's/\<idlib\()\?\)$/idlib GL\1/' neo/CMakeLists.txt
  '';

  preConfigure = ''
    cd "$(ls -d dhewm3-*.src)"/neo
  '';

  nativeBuildInputs = [
    cmake
    copyDesktopItems
  ];
  buildInputs = [
    SDL2
    libGLU
    libGL
    zlib
    libjpeg
    libogg
    libvorbis
    openal
    curl
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "dhewm3";
      exec = "dhewm3";
      desktopName = "Doom 3";
      categories = [ "Game" ];
    })
  ];

  hardeningDisable = [ "format" ];

  meta = with lib; {
    homepage = "https://github.com/dhewm/dhewm3";
    description = "Doom 3 port to SDL";
    mainProgram = "dhewm3";
    license = lib.licenses.gpl3;
    maintainers = [ ];
    platforms = with platforms; linux;
  };
}
