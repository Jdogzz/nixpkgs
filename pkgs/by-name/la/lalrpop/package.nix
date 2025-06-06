{
  lib,
  rustPlatform,
  fetchFromGitHub,
  replaceVars,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "lalrpop";
  version = "0.20.2";

  src = fetchFromGitHub {
    owner = "lalrpop";
    repo = "lalrpop";
    tag = version;
    hash = "sha256-cFwBck+bdOjhF6rQQj03MOO+XCsrII5c4Xvhsw12ETA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-c0xota0APLm/xQSH2Orn0PgCKuhUVhXEtzNge/GeYo0=";

  patches = [
    (replaceVars ./use-correct-binary-path-in-tests.patch {
      target_triple = stdenv.hostPlatform.rust.rustcTarget;
    })
  ];

  buildAndTestSubdir = "lalrpop";

  # there are some tests in lalrpop-test and some in lalrpop
  checkPhase = ''
    buildAndTestSubdir=lalrpop-test cargoCheckHook
    cargoCheckHook
  '';

  meta = with lib; {
    description = "LR(1) parser generator for Rust";
    homepage = "https://github.com/lalrpop/lalrpop";
    changelog = "https://github.com/lalrpop/lalrpop/blob/${src.rev}/RELEASES.md";
    license = with licenses; [
      asl20 # or
      mit
    ];
    mainProgram = "lalrpop";
    maintainers = with maintainers; [ chayleaf ];
  };
}
