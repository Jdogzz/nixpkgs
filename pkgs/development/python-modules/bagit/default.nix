{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gettext,
  mock,
  pytestCheckHook,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "bagit";
  version = "1.8.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "LibraryOfCongress";
    repo = "bagit-python";
    tag = "v${version}";
    hash = "sha256-t01P7MPWgOrktuW2zF0TIzt6u/jkLmrpD2OnqawhJaI=";
  };

  nativeBuildInputs = [
    gettext
    setuptools-scm
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];
  pytestFlagsArray = [ "test.py" ];
  pythonImportsCheck = [ "bagit" ];

  meta = with lib; {
    description = "Python library and command line utility for working with BagIt style packages";
    mainProgram = "bagit.py";
    homepage = "https://libraryofcongress.github.io/bagit-python/";
    license = with licenses; [ publicDomain ];
    maintainers = with maintainers; [ veprbl ];
  };
}
