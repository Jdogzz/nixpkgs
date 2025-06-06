{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libX11,
  libXcursor,
  libXmu,
  libXpm,
  libheif,
  pkg-config,
  wayland,
  xbitmaps,
}:

buildGoModule rec {
  pname = "wallutils";
  version = "5.12.9";

  src = fetchFromGitHub {
    owner = "xyproto";
    repo = "wallutils";
    tag = version;
    hash = "sha256-kayzaNOV2xTjbMeGUJ1jMLGxcVZzYkMLr6qWlAupPKM=";
  };

  vendorHash = null;

  patches = [
    ./000-add-nixos-dirs-to-default-wallpapers.patch
  ];

  excludedPackages = [
    "./pkg/event/cmd" # Development tools
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libX11
    libXcursor
    libXmu
    libXpm
    libheif
    wayland
    xbitmaps
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  preCheck = ''
    export XDG_RUNTIME_DIR=$(mktemp -d)
  '';

  checkFlags =
    let
      skippedTests = [
        "TestClosest" # Requiring Wayland or X
        "TestEveryMinute" # Blocking
        "TestNewSimpleEvent" # Blocking
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  meta = {
    description = "Utilities for handling monitors, resolutions, and (timed) wallpapers";
    inherit (src.meta) homepage;
    license = lib.licenses.bsd3;
    maintainers = [ ];
    inherit (wayland.meta) platforms;
    badPlatforms = lib.platforms.darwin;
  };
}
