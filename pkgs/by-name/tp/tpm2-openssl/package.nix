{
  stdenv,
  lib,
  autoreconfHook,
  fetchFromGitHub,
  autoconf-archive,
  nix-update-script,
  pkg-config,
  openssl,
  tpm2-tss,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tpm2-openssl";
  version = "1.3.0";
  src = fetchFromGitHub {
    owner = "tpm2-software";
    repo = "tpm2-openssl";
    tag = finalAttrs.version;
    hash = "sha256-CCTR7qBqI/y+jLBEEcgRanYOBNUYM/sH/hCqOLGA4QM=";
  };

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    pkg-config
  ];

  buildInputs = [
    openssl
    tpm2-tss
  ];

  configureFlags = [ "--with-modulesdir=$$out/lib/ossl-modules" ];

  postPatch = ''
    echo ${finalAttrs.version} > VERSION
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "OpenSSL Provider for TPM2 integration";
    homepage = "https://github.com/tpm2-software/tpm2-openssl";
    license = licenses.bsd3;
    maintainers = with maintainers; [ stv0g ];
    platforms = platforms.linux;
  };
})
