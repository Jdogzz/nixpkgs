{
  lib,
  stdenv,
  fetchFromGitLab,
  replaceVars,
  meson,
  ninja,
  pkg-config,
  vala,
  gettext,
  itstool,
  desktop-file-utils,
  glib,
  glib-networking,
  gtk4,
  coreutils,
  libsoup_3,
  libsecret,
  libadwaita,
  wrapGAppsHook4,
  libgpg-error,
  json-glib,
  duplicity,
  rclone,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "deja-dup";
  version = "47.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "deja-dup";
    tag = finalAttrs.version;
    hash = "sha256-MjZ+NkNAzwEnC9R48Q5Cb3+c5jM7ooOv7+5TQ6Xo4LM=";
  };

  patches = [
    (replaceVars ./fix-paths.patch {
      inherit coreutils;
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    gettext
    itstool
    desktop-file-utils
    wrapGAppsHook4
  ];

  buildInputs = [
    libsoup_3
    glib
    glib-networking
    gtk4
    libsecret
    libadwaita
    libgpg-error
    json-glib
  ];

  mesonFlags = [
    "-Dduplicity_command=${lib.getExe duplicity}"
    "-Drclone_command=${lib.getExe rclone}"
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      # Required by duplicity
      --prefix PATH : "${lib.makeBinPath [ rclone ]}"
    )
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Simple backup tool";
    longDescription = ''
      Déjà Dup is a simple backup tool. It hides the complexity \
      of backing up the Right Way (encrypted, off-site, and regular) \
      and uses duplicity as the backend.
    '';
    homepage = "https://apps.gnome.org/DejaDup/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jtojnar ] ++ lib.teams.gnome-circle.members;
    platforms = platforms.linux;
    mainProgram = "deja-dup";
  };
})
