{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "scryer-prolog";
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "mthom";
    repo = "scryer-prolog";
    tag = "v${version}";
    hash = "sha256-0c0MsjrHRitg+5VEHB9/iSuiqcPztF+2inDZa9fQpwU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-CuCVofzKd/VPBTZY+ubk5wP9akt9kQLyi221fg7yt3M=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  CARGO_FEATURE_USE_SYSTEM_LIBS = true;

  meta = with lib; {
    description = "Modern Prolog implementation written mostly in Rust";
    mainProgram = "scryer-prolog";
    homepage = "https://github.com/mthom/scryer-prolog";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [
      malbarbo
      wkral
    ];
  };
}
