{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest7CheckHook,
  setuptools,
  jsonschema,
  pyyaml,
  jinja2,
  termcolor,
}:

buildPythonPackage rec {
  pname = "barectf";
  version = "3.1.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "efficios";
    repo = "barectf";
    tag = "v${version}";
    hash = "sha256-JelFfd3WS012dveNlIljhLdyPmgE9VEOXoZE3MBA/Gw=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  pythonRelaxDeps = [
    "jsonschema"
    "pyyaml"
    "termcolor"
  ];

  propagatedBuildInputs = [
    setuptools # needs pkg_resources at runtime
    jsonschema
    pyyaml
    jinja2
    termcolor
  ];

  pythonImportsCheck = [ "barectf" ];

  nativeCheckInputs = [ pytest7CheckHook ];

  meta = with lib; {
    description = "Generator of ANSI C tracers which output CTF data streams";
    mainProgram = "barectf";
    homepage = "https://github.com/efficios/barectf";
    license = licenses.mit;
    maintainers = with maintainers; [ Madouura ];
  };
}
