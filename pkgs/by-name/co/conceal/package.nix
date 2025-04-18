{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  testers,
  conceal,
}:

rustPlatform.buildRustPackage rec {
  pname = "conceal";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "TD-Sky";
    repo = "conceal";
    tag = "v${version}";
    sha256 = "sha256-BYLDSRgBba6SoGsL/NTV/OTG1/V9RSr8lisj42JqBRM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-yCHN7N+hRrWfuCEBA6gh2S/rRP+ZkHCjFBGGY9/LTb4=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion \
      completions/{cnc/cnc,conceal/conceal}.{bash,fish} \
      --zsh completions/{cnc/_cnc,conceal/_conceal}
  '';

  # There are not any tests in source project.
  doCheck = false;

  passthru.tests = testers.testVersion {
    package = conceal;
    command = "conceal --version";
    version = "conceal ${version}";
  };

  meta = with lib; {
    description = "Trash collector written in Rust";
    homepage = "https://github.com/TD-Sky/conceal";
    license = licenses.mit;
    maintainers = with maintainers; [
      jedsek
      kashw2
    ];
    broken = stdenv.hostPlatform.isDarwin;
  };
}
