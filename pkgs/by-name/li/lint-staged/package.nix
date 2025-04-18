{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
  lint-staged,
}:

buildNpmPackage rec {
  pname = "lint-staged";
  version = "15.5.0";

  src = fetchFromGitHub {
    owner = "okonet";
    repo = "lint-staged";
    tag = "v${version}";
    hash = "sha256-xZ4fKwryGHVD1AhSKJVvBGIDJin10YejKxDp1yMi8Pg=";
  };

  npmDepsHash = "sha256-KIZgJaVGwPAsMtKMINqSnqSuD3iJIqRmoUDkU4iPh/s=";

  dontNpmBuild = true;

  # Fixes `lint-staged --version` output
  postPatch = ''
    substituteInPlace package.json --replace \
      '"version": "0.0.0-development"' \
      '"version": "${version}"'
  '';

  passthru.tests.version = testers.testVersion { package = lint-staged; };

  meta = with lib; {
    description = "Run linters on git staged files";
    longDescription = ''
      Run linters against staged git files and don't let 💩 slip into your code base!
    '';
    homepage = src.meta.homepage;
    license = licenses.mit;
    maintainers = with maintainers; [ DamienCassou ];
    mainProgram = "lint-staged";
  };
}
