{
  lib,
  buildPythonPackage,
  fetchPypi,
  cmake,
  perl,
  stdenv,
  CoreFoundation,
  Security,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "awscrt";
  version = "0.25.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Nd4fqCQqlRo7pbOl6P+/kdTGpr/o5IjIMIrP6KDFe3w=";
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    CoreFoundation
    Security
  ];

  nativeBuildInputs = [ cmake ] ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ perl ];

  dontUseCmakeConfigure = true;

  pythonImportsCheck = [ "awscrt" ];

  # Unable to import test module
  # https://github.com/awslabs/aws-crt-python/issues/281
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/awslabs/aws-crt-python";
    changelog = "https://github.com/awslabs/aws-crt-python/releases/tag/v${version}";
    description = "Python bindings for the AWS Common Runtime";
    license = licenses.asl20;
    maintainers = with maintainers; [ davegallant ];
  };
}
