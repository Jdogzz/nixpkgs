{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:
buildGoModule rec {
  pname = "kconf";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "particledecay";
    repo = "kconf";
    tag = "v${version}";
    sha256 = "sha256-bLyLXkXOZRFaplv5sY0TgFffvbA3RUwz6b+7h3MN7kA=";
  };

  vendorHash = "sha256-REguLiYlcC2Q6ao2oMl92/cznW+E8MO2UGhQKRXZ1vQ=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/particledecay/kconf/build.Version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd kconf \
      --bash <($out/bin/kconf completion bash) \
      --fish <($out/bin/kconf completion fish) \
      --zsh <($out/bin/kconf completion zsh)
  '';

  meta = with lib; {
    description = "Opinionated command line tool for managing multiple kubeconfigs";
    mainProgram = "kconf";
    homepage = "https://github.com/particledecay/kconf";
    license = licenses.mit;
    maintainers = with maintainers; [
      thmzlt
      sailord
      vinetos
    ];
  };
}
