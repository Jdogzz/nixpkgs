{
  lib,
  stdenv,
  fetchFromGitHub,
  ocaml,
  findlib,
  version ? if lib.versionAtLeast ocaml.version "4.08" then "0.16.1" else "0.14.3",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ocaml${ocaml.version}-ocamlbuild";
  inherit version;

  src = fetchFromGitHub {
    owner = "ocaml";
    repo = "ocamlbuild";
    tag = finalAttrs.version;
    hash =
      {
        "0.14.3" = "sha256-dfcNu4ugOYu/M0rRQla7lXum/g1UzncdLGmpPYo0QUM=";
        "0.16.1" = "sha256-RpHVX0o4QduN73j+omlZlycRJaGZWfwHO5kq/WsEGZE=";
      }
      ."${finalAttrs.version}";
  };

  createFindlibDestdir = true;

  nativeBuildInputs = [
    ocaml
    findlib
  ];
  strictDeps = true;

  # x86_64-unknown-linux-musl-ld: -r and -pie may not be used together
  hardeningDisable = lib.optional stdenv.hostPlatform.isStatic "pie";

  configurePhase = ''
    runHook preConfigure

    make -f configure.make Makefile.config \
      "OCAMLBUILD_PREFIX=$out" \
      "OCAMLBUILD_BINDIR=$out/bin" \
      "OCAMLBUILD_MANDIR=$out/share/man" \
      "OCAMLBUILD_LIBDIR=$OCAMLFIND_DESTDIR"

    runHook postConfigure
  '';

  meta = with lib; {
    description = "Build system with builtin rules to easily build most OCaml projects";
    homepage = "https://github.com/ocaml/ocamlbuild/";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ vbgl ];
    mainProgram = "ocamlbuild";
    inherit (ocaml.meta) platforms;
  };
})
