{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  angstrom,
  faraday,
  result,
  alcotest,
}:

buildDunePackage rec {
  pname = "httpaf";
  version = "0.7.1";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "inhabitedtype";
    repo = pname;
    tag = version;
    sha256 = "0zk78af3qyvf6w66mg8sxygr6ndayzqw5s3zfxibvn121xwni26z";
  };

  checkInputs = [ alcotest ];
  propagatedBuildInputs = [
    angstrom
    faraday
    result
  ];
  doCheck = true;

  meta = {
    description = "High-performance, memory-efficient, and scalable web server for OCaml";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
  };
}
