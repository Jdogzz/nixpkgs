{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  which,
}:

stdenv.mkDerivation rec {
  pname = "fatrace";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "martinpitt";
    repo = "fatrace";
    tag = version;
    sha256 = "sha256-QkavhxORENQSLUg4tq+W1WB7zSYYinWOOYPqNbv+pEI=";
  };

  buildInputs = [
    python3
    which
  ];

  postPatch = ''
    substituteInPlace power-usage-report \
      --replace "'which'" "'${which}/bin/which'"
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Report system-wide file access events";
    homepage = "https://github.com/martinpitt/fatrace";
    license = licenses.gpl3Plus;
    longDescription = ''
      fatrace reports file access events from all running processes.
      Its main purpose is to find processes which keep waking up the disk
      unnecessarily and thus prevent some power saving.
      Requires a Linux kernel with the FANOTIFY configuration option enabled.
      Enabling X86_MSR is also recommended for power-usage-report on x86.
    '';
    platforms = platforms.linux;
  };
}
