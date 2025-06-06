{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyqt5,
  pytestCheckHook,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "anyqt";
  version = "0.2.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ales-erjavec";
    repo = "anyqt";
    tag = version;
    hash = "sha256-iDUgu+x9rnpxpHzO7Rf2rJFXsheivrK7HI3FUbomkTU=";
  };

  nativeCheckInputs = [
    pyqt5
    pytestCheckHook
  ];

  # All of these fail because Qt modules cannot be imported
  disabledTestPaths = [
    "tests/test_qabstractitemview.py"
    "tests/test_qaction_set_menu.py"
    "tests/test_qactionevent_action.py"
    "tests/test_qfontdatabase_static.py"
    "tests/test_qpainter_draw_pixmap_fragments.py"
    "tests/test_qsettings.py"
    "tests/test_qstandarditem_insertrow.py"
    "tests/test_qtest.py"
  ];

  pythonImportsCheck = [ "AnyQt" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "PyQt/PySide compatibility layer";
    homepage = "https://github.com/ales-erjavec/anyqt";
    license = [ lib.licenses.gpl3Only ];
    maintainers = [ lib.maintainers.lucasew ];
  };
}
