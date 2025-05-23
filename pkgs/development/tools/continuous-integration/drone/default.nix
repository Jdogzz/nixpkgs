{
  lib,
  fetchFromGitHub,
  buildGoModule,
  enableUnfree ? true,
}:

buildGoModule rec {
  pname = "drone.io${lib.optionalString (!enableUnfree) "-oss"}";
  version = "2.26.0";

  src = fetchFromGitHub {
    owner = "harness";
    repo = "drone";
    tag = "v${version}";
    sha256 = "sha256-rTMu3wd/drxALAZB0O5bAJuWdYsHSwwOD4nbAFIhXbg=";
  };

  vendorHash = "sha256-9jzhoFN7aAUgPxENPuGYR41gXLzSv1VtnTPB38heVlI=";

  tags = lib.optionals (!enableUnfree) [
    "oss"
    "nolimit"
  ];

  doCheck = false;

  meta = with lib; {
    description = "Continuous Integration platform built on container technology";
    mainProgram = "drone-server";
    homepage = "https://github.com/harness/drone";
    maintainers = with maintainers; [
      vdemeester
      techknowlogick
    ];
    license = with licenses; if enableUnfree then unfreeRedistributable else asl20;
  };
}
