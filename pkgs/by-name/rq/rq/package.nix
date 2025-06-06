{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "rq";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "dflemstr";
    repo = pname;
    tag = "v${version}";
    sha256 = "sha256-QyYTbMXikLSe3eYJRUALQJxUJjA6VlvaLMwGrxIKfZI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-BwbGiLoygNUua+AAKw/JAAG1kuWLdnP+8o+FFuvbFlM=";

  postPatch = ''
    # Remove #[deny(warnings)] which is equivalent to -Werror in C.
    # Prevents build failures when upgrading rustc, which may give more warnings.
    substituteInPlace src/lib.rs \
      --replace "#![deny(warnings)]" ""

    # build script tries to get version information from git
    # this fixes the --version output
    rm build.rs
  '';

  VERGEN_SEMVER = version;

  meta = with lib; {
    description = "Tool for doing record analysis and transformation";
    mainProgram = "rq";
    homepage = "https://github.com/dflemstr/rq";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [
      aristid
      Br1ght0ne
      figsoda
    ];
  };
}
