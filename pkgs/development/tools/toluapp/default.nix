{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  lua,
}:

stdenv.mkDerivation rec {
  version = "1.0.93";
  pname = "toluapp";

  src = fetchFromGitHub {
    owner = "LuaDist";
    repo = "toluapp";
    tag = version;
    sha256 = "0zd55bc8smmgk9j4cf0jpibb03lgsvl0knpwhplxbv93mcdnw7s0";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ lua ];

  patches = [
    ./environ-and-linux-is-kinda-posix.patch
    ./headers.patch
  ];

  meta = with lib; {
    description = "Tool to integrate C/Cpp code with Lua";
    homepage = "http://www.codenix.com/~tolua/";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "tolua++";
    platforms = with platforms; unix;
  };
}
