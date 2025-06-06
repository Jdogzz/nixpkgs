{
  lib,
  stdenv,
  fetchFromGitLab,
  c-ares,
  dbus,
  glib,
  libphonenumber,
  libsoup_3,
  meson,
  mobile-broadband-provider-info,
  modemmanager,
  ninja,
  pkg-config,
  protobuf,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mmsd-tng";
  version = "2.6.3";

  src = fetchFromGitLab {
    owner = "kop316";
    repo = "mmsd";
    tag = finalAttrs.version;
    hash = "sha256-kXl+T5A8Qw0PmJ47sned8dzTIYUmaWc8w6X6BLEdLIg=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    c-ares
    dbus
    glib
    libphonenumber
    libsoup_3
    mobile-broadband-provider-info
    modemmanager
    protobuf
  ];

  doCheck = true;

  meta = {
    description = "Multimedia Messaging Service Daemon - The Next Generation";
    homepage = "https://gitlab.com/kop316/mmsd";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ julm ];
    platforms = lib.platforms.linux;
    mainProgram = "mmsdtng";
  };
})
