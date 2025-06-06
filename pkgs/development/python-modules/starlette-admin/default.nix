{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  aiosqlite,
  arrow,
  babel,
  cacert,
  colour,
  fasteners,
  httpx,
  jinja2,
  mongoengine,
  motor,
  passlib,
  phonenumbers,
  pillow,
  psycopg2,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  python-multipart,
  requests,
  sqlalchemy,
  sqlalchemy-file,
  sqlalchemy-utils,
  sqlmodel,
  starlette,
}:

buildPythonPackage rec {
  pname = "starlette-admin";
  version = "0.14.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jowilf";
    repo = "starlette-admin";
    tag = version;
    hash = "sha256-DoYD8Hc5pd68+BhASw3mwwCdhu0vYHiELjVmVwU8FHs=";
  };

  # recreates https://github.com/jowilf/starlette-admin/pull/630 which cannot be cherry-picked
  postPatch = ''
    test_files_to_fix=(
      tests/mongoengine/test_auth.py
      tests/odmantic/test_async_engine.py
      tests/odmantic/test_auth.py
      tests/odmantic/test_sync_engine.py
      tests/sqla/test_async_engine.py
      tests/sqla/test_auth.py
      tests/sqla/test_multiple_pks.py
      tests/sqla/test_sqla_and_pydantic.py
      tests/sqla/test_sqla_utils.py
      tests/sqla/test_sqlmodel.py
      tests/sqla/test_sync_engine.py
      tests/sqla/test_view_serialization.py
      tests/test_auth.py
    )
    substituteInPlace "''${test_files_to_fix[@]}" \
      --replace-fail  \
        'from httpx import AsyncClient'  \
        'from httpx import AsyncClient, ASGITransport' \
      --replace-fail \
        'AsyncClient(app=app,'  \
        'AsyncClient(transport=ASGITransport(app=app),'
  '';

  build-system = [ hatchling ];

  dependencies = [
    jinja2
    python-multipart
    starlette
  ];

  optional-dependencies = {
    i18n = [ babel ];
  };

  nativeCheckInputs = [
    aiosqlite
    arrow
    babel
    cacert
    colour
    fasteners
    httpx
    mongoengine
    motor
    passlib
    phonenumbers
    pillow
    psycopg2
    pydantic
    pytest-asyncio
    pytestCheckHook
    requests
    sqlalchemy
    sqlalchemy-file
    sqlalchemy-utils
    sqlmodel
  ];

  preCheck = ''
    # used in get_test_container in tests/sqla/utils.py
    # fixes FileNotFoundError: [Errno 2] No such file or directory: '/tmp/storage/...'
    mkdir .storage
    export LOCAL_PATH="$PWD/.storage"
  '';

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # flaky, depends on test order
    "test_ensuring_pk"
    # flaky, of-by-one
    "test_api"
  ];

  disabledTestPaths =
    [
      # odmantic is not packaged
      "tests/odmantic"
      # needs mongodb running on port 27017
      "tests/mongoengine"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # very flaky, sandbox issues?
      # libcloud.storage.types.ContainerDoesNotExistError
      # sqlite3.OperationalError: attempt to write a readonly database
      "tests/sqla/test_sync_engine.py"
      "tests/sqla/test_async_engine.py"
    ];

  pythonImportsCheck = [
    "starlette_admin"
    "starlette_admin.actions"
    "starlette_admin.base"
    "starlette_admin.fields"
    "starlette_admin.i18n"
    "starlette_admin.tools"
    "starlette_admin.views"
  ];

  meta = with lib; {
    description = "Fast, beautiful and extensible administrative interface framework for Starlette & FastApi applications";
    homepage = "https://github.com/jowilf/starlette-admin";
    changelog = "https://github.com/jowilf/starlette-admin/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ pbsds ];
  };
}
