{
  stdenv,
  lib,
  fetchFromGitHub,
  bzip2,
  expat,
  libedit,
  lmdb,
  openssl,
  libxcrypt,
  python3, # for tests only
  cpp11 ? false,
}:

let
  zeroc_mcpp = stdenv.mkDerivation rec {
    pname = "zeroc-mcpp";
    version = "2.7.2.14";

    src = fetchFromGitHub {
      owner = "zeroc-ice";
      repo = "mcpp";
      tag = "v${version}";
      sha256 = "1psryc2ql1cp91xd3f8jz84mdaqvwzkdq2pr96nwn03ds4cd88wh";
    };

    configureFlags = [ "--enable-mcpplib" ];
    installFlags = [ "PREFIX=$(out)" ];
  };

in
stdenv.mkDerivation rec {
  pname = "zeroc-ice";
  version = "3.7.10";

  src = fetchFromGitHub {
    owner = "zeroc-ice";
    repo = "ice";
    tag = "v${version}";
    hash = "sha256-l3cKsR8HSdtFGw1S12xueQOu/U9ABlOxQQtbHBj2izs=";
  };

  buildInputs = [
    zeroc_mcpp
    bzip2
    expat
    libedit
    lmdb
    openssl
    libxcrypt
  ];

  preBuild = ''
    makeFlagsArray+=(
      "prefix=$out"
      "OPTIMIZE=yes"
      "USR_DIR_INSTALL=yes"
      "LANGUAGES=cpp"
      "CONFIGS=${if cpp11 then "cpp11-shared" else "shared"}"
      "SKIP=slice2py" # provided by a separate package
    )
  '';

  enableParallelBuilding = true;

  outputs = [
    "out"
    "bin"
    "dev"
  ];

  doCheck = true;
  nativeCheckInputs = with python3.pkgs; [ passlib ];
  checkPhase =
    let
      # these tests require network access so we need to skip them.
      brokenTests = map lib.escapeRegex [
        "Ice/udp"
        "Glacier2"
        "IceGrid/simple"
        "IceStorm"
        "IceDiscovery/simple"

        # FIXME: certificate expired, remove for next release?
        "IceSSL/configuration"
      ];
      # matches CONFIGS flag in makeFlagsArray
      configFlag = lib.optionalString cpp11 "--config=cpp11-shared";
    in
    ''
      runHook preCheck
      ${python3.interpreter} ./cpp/allTests.py ${configFlag} --rfilter='${lib.concatStringsSep "|" brokenTests}'
      runHook postCheck
    '';

  postInstall = ''
    mkdir -p $bin $dev/share
    mv $out/bin $bin
    mv $out/share/ice $dev/share
  '';

  meta = with lib; {
    homepage = "https://www.zeroc.com/ice.html";
    description = "Internet communications engine";
    license = licenses.gpl2Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ abbradar ];
    broken = stdenv.hostPlatform.isDarwin;
  };
}
