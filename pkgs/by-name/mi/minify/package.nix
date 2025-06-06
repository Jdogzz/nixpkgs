{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
  testers,
  minify,
}:

buildGoModule rec {
  pname = "minify";
  version = "2.22.4";

  src = fetchFromGitHub {
    owner = "tdewolff";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-sN3gGxUOWNFBB+iz6i+a0SP8my+IdbMXAVd/bWzzKms=";
  };

  vendorHash = "sha256-PxmtYVMkZcJvaM9CYSy5OSUkpyhL1VLwkXoY7uIe7Q8=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  subPackages = [ "cmd/minify" ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      inherit version;
      package = minify;
      command = "minify --version";
    };
  };

  postInstall = ''
    installShellCompletion --cmd minify --bash cmd/minify/bash_completion
  '';

  meta = with lib; {
    description = "Go minifiers for web formats";
    homepage = "https://go.tacodewolff.nl/minify";
    downloadPage = "https://github.com/tdewolff/minify";
    changelog = "https://github.com/tdewolff/minify/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ gaelreyrol ];
    mainProgram = "minify";
  };
}
