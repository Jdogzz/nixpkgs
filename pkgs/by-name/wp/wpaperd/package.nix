{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libxkbcommon,
  wayland,
  libGL,
}:

rustPlatform.buildRustPackage rec {
  pname = "wpaperd";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "danyspin97";
    repo = "wpaperd";
    tag = version;
    hash = "sha256-L3xoEhVjbJoPsGgie95SIxpRDCV5ZZcrfL01TPAffZc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-F4u+d0HZBC5JWS25EGyWoeLV7wkmI0n4/pVjp61qSu0=";

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    wayland
    libGL
    libxkbcommon
  ];

  meta = with lib; {
    description = "Minimal wallpaper daemon for Wayland";
    longDescription = ''
      It allows the user to choose a different image for each output (aka for each monitor)
      just as swaybg. Moreover, a directory can be chosen and wpaperd will randomly choose
      an image from it. Optionally, the user can set a duration, after which the image
      displayed will be changed with another random one.
    '';
    homepage = "https://github.com/danyspin97/wpaperd";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      DPDmancul
      fsnkty
    ];
    mainProgram = "wpaperd";
  };
}
