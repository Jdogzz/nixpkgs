{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
  DiskArbitration,
  pkg-config,
  bzip2,
  libarchive,
  libconfuse,
  libsodium,
  xz,
  zlib,
  coreutils,
  dosfstools,
  mtools,
  unzip,
  zip,
  which,
  xdelta,
}:

stdenv.mkDerivation rec {
  pname = "fwup";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "fhunleth";
    repo = "fwup";
    tag = "v${version}";
    sha256 = "sha256-WYolvHAK7l1HJZuBXsPJ+X6uzWFHBlHELx4zvD/S934=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs =
    [
      bzip2
      libarchive
      libconfuse
      libsodium
      xz
      zlib
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      DiskArbitration
    ];

  propagatedBuildInputs =
    [
      coreutils
      unzip
      zip
    ]
    ++ lib.optionals doCheck [
      mtools
      dosfstools
    ];

  nativeCheckInputs = [
    which
    xdelta
  ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = with lib; {
    description = "Configurable embedded Linux firmware update creator and runner";
    homepage = "https://github.com/fhunleth/fwup";
    license = licenses.asl20;
    maintainers = [ maintainers.georgewhewell ];
    platforms = platforms.all;
  };
}
