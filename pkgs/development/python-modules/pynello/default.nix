{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python-dateutil,
  pythonOlder,
  requests,
  requests-oauthlib,
}:

buildPythonPackage rec {
  pname = "pynello";
  version = "2.0.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "pschmitt";
    repo = pname;
    tag = version;
    hash = "sha256-sUy37sEPEMyFYFVBzFVdcg31nZAyC+Ricm4LqxmjuQQ=";
  };

  propagatedBuildInputs = [
    python-dateutil
    requests
    requests-oauthlib
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pynello" ];

  meta = with lib; {
    description = "Python library for nello.io intercoms";
    mainProgram = "nello";
    homepage = "https://github.com/pschmitt/pynello";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
