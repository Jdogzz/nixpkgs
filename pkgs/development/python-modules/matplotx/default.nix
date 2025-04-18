{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  matplotlib,
  numpy,
  networkx,
  pypng,
  scipy,
}:

buildPythonPackage rec {
  pname = "matplotx";
  version = "0.3.10";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "nschloe";
    repo = "matplotx";
    tag = "v${version}";
    hash = "sha256-EWEiEY23uFwd/vgWVLCH/buUmgRqz1rqqlJEdXINYMg=";
  };

  propagatedBuildInputs = [
    setuptools
    matplotlib
    numpy
  ];

  optional-dependencies = {
    all = [
      networkx
      pypng
      scipy
    ];
    contour = [ networkx ];
    spy = [
      pypng
      scipy
    ];
  };

  # This variable is needed to suppress the "Trace/BPT trap: 5" error in Darwin's checkPhase.
  # Not sure of the details, but we can avoid it by changing the matplotlib backend during testing.
  env.MPLBACKEND = lib.optionalString stdenv.hostPlatform.isDarwin "Agg";

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.all;

  disabledTestPaths = [
    "tests/test_spy.py" # Requires meshzoo (non-free) and pytest-codeblocks (not packaged)
  ];

  pythonImportsCheck = [ "matplotx" ];

  meta = {
    homepage = "https://github.com/nschloe/matplotx";
    description = "More styles and useful extensions for Matplotlib";
    mainProgram = "matplotx";
    changelog = "https://github.com/nschloe/matplotx/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ swflint ];
  };
}
