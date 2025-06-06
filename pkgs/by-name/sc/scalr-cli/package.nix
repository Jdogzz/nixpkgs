{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "scalr-cli";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "Scalr";
    repo = "scalr-cli";
    tag = "v${version}";
    hash = "sha256-mDcirYhqpfeS2Wt9MnYPmTn/QZa85vlrN2uUkA1+7A4=";
  };

  vendorHash = "sha256-TUf+0Z0yBDOpzMuETn+FCAPXWvQltjRhwQ3Xz0X6YOI=";

  ldflags = [
    "-s"
    "-w"
  ];

  preConfigure = ''
    # Set the version.
    substituteInPlace main.go --replace '"0.0.0"' '"${version}"'
  '';

  postInstall = ''
    mv $out/bin/cli $out/bin/scalr
  '';

  doCheck = false; # Skip tests as they require creating actual Scalr resources.

  meta = with lib; {
    description = "Command-line tool that communicates directly with the Scalr API";
    homepage = "https://github.com/Scalr/scalr-cli";
    changelog = "https://github.com/Scalr/scalr-cli/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ dylanmtaylor ];
    mainProgram = "scalr";
  };
}
