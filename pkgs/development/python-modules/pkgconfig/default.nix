{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  poetry-core,
  pkg-config,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pkgconfig";
  version = "1.5.5";
  format = "pyproject";

  inherit (pkg-config)
    setupHooks
    wrapperName
    suffixSalt
    targetPrefix
    baseBinName
    ;

  src = fetchFromGitHub {
    owner = "matze";
    repo = "pkgconfig";
    tag = "v${version}";
    hash = "sha256-uuLUGRNLCR3NS9g6OPCI+qG7tPWsLhI3OE5WmSI3vm8=";
  };

  postPatch = ''
    substituteInPlace pkgconfig/pkgconfig.py \
      --replace "pkg_config_exe = os.environ.get('PKG_CONFIG', None) or 'pkg-config'" "pkg_config_exe = '${pkg-config}/bin/${pkg-config.targetPrefix}pkg-config'"

    # those pc files are missing and pkg-config validates that they exist
    substituteInPlace data/fake-openssl.pc \
      --replace "Requires: libssl libcrypto" ""
  '';

  nativeBuildInputs = [ poetry-core ];

  # ModuleNotFoundError: No module named 'distutils'
  # https://github.com/matze/pkgconfig/issues/64
  doCheck = pythonOlder "3.12";

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pkgconfig" ];

  meta = with lib; {
    description = "Interface Python with pkg-config";
    homepage = "https://github.com/matze/pkgconfig";
    license = licenses.mit;
    maintainers = with maintainers; [ nickcao ];
  };
}
