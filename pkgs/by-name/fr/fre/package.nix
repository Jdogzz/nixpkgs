{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "fre";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "camdencheek";
    repo = "fre";
    tag = "v${version}";
    hash = "sha256-cYqEPohqUmewvBUoGJQfa4ATxw2uny5+nUKtNzrxK38=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-07qKG4ju2UOkTcgWAl2U0uqQZyiosK1UH/M2BvwMAaU=";

  meta = with lib; {
    description = "CLI tool for tracking your most-used directories and files";
    homepage = "https://github.com/camdencheek/fre";
    changelog = "https://github.com/camdencheek/fre/blob/${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ gaykitty ];
    mainProgram = "fre";
  };
}
