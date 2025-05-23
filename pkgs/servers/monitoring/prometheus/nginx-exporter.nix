{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "nginx_exporter";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "nginxinc";
    repo = "nginx-prometheus-exporter";
    tag = "v${version}";
    sha256 = "sha256-yujMufcL4uJHxbEd8mwqxPmPlopVm6szkDxz+GZITio=";
  };

  vendorHash = "sha256-csBnUeuzkqgk5+62w0GZS2gX5jscPhN1z85KBVCMA0I=";

  ldflags =
    let
      t = "github.com/prometheus/common/version";
    in
    [
      "-s"
      "-w"
      "-X ${t}.Version=${version}"
      "-X ${t}.Branch=unknown"
      "-X ${t}.BuildUser=nix@nixpkgs"
      "-X ${t}.BuildDate=unknown"
    ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) nginx; };

  meta = with lib; {
    description = "NGINX Prometheus Exporter for NGINX and NGINX Plus";
    mainProgram = "nginx-prometheus-exporter";
    homepage = "https://github.com/nginxinc/nginx-prometheus-exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [
      benley
      fpletz
      willibutz
      globin
    ];
  };
}
