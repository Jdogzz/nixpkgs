{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
}:

stdenv.mkDerivation rec {
  version = "1.2.3";
  pname = "nginx-config-formatter";

  src = fetchFromGitHub {
    owner = "slomkowski";
    repo = "nginx-config-formatter";
    tag = "v${version}";
    sha256 = "sha256-nYaBdVsq7aLE9P1bQlJlQkrk/cq7C1hxM5XtCGyEzC0=";
  };

  buildInputs = [ python3 ];

  doCheck = true;
  checkPhase = ''
    python3 $src/test_nginxfmt.py
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -m 0755 $src/nginxfmt.py $out/bin/nginxfmt
  '';

  meta = with lib; {
    description = "nginx config file formatter";
    maintainers = with maintainers; [ Baughn ];
    license = licenses.asl20;
    homepage = "https://github.com/slomkowski/nginx-config-formatter";
    mainProgram = "nginxfmt";
  };
}
