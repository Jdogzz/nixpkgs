{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  gdk-pixbuf,
  gtk4,
  libadwaita,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "fclones-gui";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "pkolaczk";
    repo = "fclones-gui";
    tag = "v${version}";
    hash = "sha256-ad7wyoCjSQ8i6c+4IorImqAY2Q6pwBtI2JkkbkGa46U=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-01HNWhHfbun+Er39eN5tEmqXMGDsBQrZtVTA9R7kifo=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs =
    [
      gdk-pixbuf
      gtk4
      libadwaita
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk_11_0.frameworks.IOKit
    ];

  postInstall = ''
    substituteInPlace snap/gui/fclones-gui.desktop \
      --replace 'Icon=''${SNAP}/meta/gui/fclones-gui.png' Icon=fclones-gui

    install -Dm444 snap/gui/fclones-gui.desktop -t $out/share/applications
    install -Dm444 snap/gui/fclones-gui.png -t $out/share/pixmaps
  '';

  meta = with lib; {
    description = "Interactive duplicate file remover";
    mainProgram = "fclones-gui";
    homepage = "https://github.com/pkolaczk/fclones-gui";
    changelog = "https://github.com/pkolaczk/fclones-gui/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
