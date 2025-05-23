{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "rcp";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "wykurz";
    repo = "rcp";
    tag = "v${version}";
    hash = "sha256-gFkrUqG3GXPAg9Zqv7Wr3axQ30axYGXw8bo+P1kmSJM=";
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin (
    with darwin.apple_sdk.frameworks;
    [
      IOKit
    ]
  );

  useFetchCargoVendor = true;
  cargoHash = "sha256-izJRaxJhLvk064JB3hlzN50V7ZWmv/X1pbL0lRCZV60=";

  RUSTFLAGS = "--cfg tokio_unstable";

  checkFlags = [
    # this test also sets setuid permissions on a test file (3oXXX) which doesn't work in a sandbox
    "--skip=copy::copy_tests::check_default_mode"
  ];

  meta = with lib; {
    changelog = "https://github.com/wykurz/rcp/releases/tag/v${version}";
    description = "Tools to efficiently copy, remove and link large filesets";
    homepage = "https://github.com/wykurz/rcp";
    license = with licenses; [ mit ];
    mainProgram = "rcp";
    maintainers = with maintainers; [ wykurz ];
    # = note: Undefined symbols for architecture x86_64: "_utimensat"
    broken = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64;
  };
}
