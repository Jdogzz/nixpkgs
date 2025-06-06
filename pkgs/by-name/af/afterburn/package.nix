{
  lib,
  openssl,
  pkg-config,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "afterburn";
  version = "5.7.0";

  src = fetchFromGitHub {
    owner = "coreos";
    repo = "afterburn";
    tag = "v${version}";
    sha256 = "sha256-j2eQUro0Rx1axBAaZDNICRrkygb4JAyxVAER/5BXXLY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-xA5hp7a4DFMh8Xrh2ft94s6aNjORKtyCuNy4GgJbSsw=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  postPatch = ''
    substituteInPlace ./systemd/afterburn-checkin.service --replace /usr/bin $out/bin
    substituteInPlace ./systemd/afterburn-firstboot-checkin.service --replace /usr/bin $out/bin
    substituteInPlace ./systemd/afterburn-sshkeys@.service.in --replace /usr/bin $out/bin
    substituteInPlace ./systemd/afterburn.service --replace /usr/bin $out/bin
  '';

  postInstall = ''
    DEFAULT_INSTANCE=root PREFIX= DESTDIR=$out make install-units
  '';

  meta = with lib; {
    homepage = "https://github.com/coreos/ignition";
    description = "One-shot cloud provider agent";
    license = licenses.asl20;
    maintainers = [ maintainers.arianvp ];
    platforms = platforms.linux;
    mainProgram = "afterburn";
  };
}
