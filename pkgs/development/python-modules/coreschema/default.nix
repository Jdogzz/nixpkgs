{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  jinja2,
  pytest,
}:

buildPythonPackage rec {
  pname = "coreschema";
  version = "0.0.4";
  format = "setuptools";

  src = fetchFromGitHub {
    repo = "python-coreschema";
    owner = "core-api";
    tag = version;
    sha256 = "027pc753mkgbb3r1v1x7dsdaarq93drx0f79ppvw9pfkcjcq6wb1";
  };

  propagatedBuildInputs = [ jinja2 ];

  nativeCheckInputs = [ pytest ];
  checkPhase = ''
    cd ./tests
    pytest
  '';

  meta = with lib; {
    description = "Python client library for Core Schema";
    homepage = "https://github.com/ivegotasthma/python-coreschema";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
