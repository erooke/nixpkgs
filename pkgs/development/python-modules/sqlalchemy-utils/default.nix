{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # runtime
  importlib-metadata,
  sqlalchemy,

  # optionals
  babel,
  arrow,
  pendulum,
  #, intervals
  phonenumbers,
  passlib,
  colour,
  python-dateutil,
  furl,
  cryptography,

  # tests
  pytestCheckHook,
  pygments,
  jinja2,
  docutils,
  flexmock,
  psycopg2,
  psycopg2cffi,
  pg8000,
  pytz,
  backports-zoneinfo,
  pymysql,
  pyodbc,

}:

buildPythonPackage rec {
  pname = "sqlalchemy-utils";
  version = "0.41.2";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "SQLAlchemy-Utils";
    hash = "sha256-vFmcjDszGeU85sXDxHESC9Ml0AcftvOKEOkk49B7mZA=";
  };

  patches = [ ./skip-database-tests.patch ];

  propagatedBuildInputs = [ sqlalchemy ] ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  optional-dependencies = {
    babel = [ babel ];
    arrow = [ arrow ];
    pendulum = [ pendulum ];
    #intervals = [ intervals ];
    phone = [ phonenumbers ];
    password = [ passlib ];
    color = [ colour ];
    timezone = [ python-dateutil ];
    url = [ furl ];
    encrypted = [ cryptography ];
  };

  nativeCheckInputs =
    [
      pytestCheckHook
      pygments
      jinja2
      docutils
      flexmock
      psycopg2
      pg8000
      pytz
      python-dateutil
      pymysql
      pyodbc
    ]
    ++ lib.flatten (builtins.attrValues optional-dependencies)
    ++ lib.optionals (pythonOlder "3.12") [
      # requires distutils, which were removed in 3.12
      psycopg2cffi
    ]
    ++ lib.optionals (pythonOlder "3.9") [ backports-zoneinfo ];

  pytestFlagsArray = [
    "--deselect tests/functions/test_database.py::TestDatabasePostgresCreateDatabaseCloseConnection::test_create_database_twice"
    "--deselect tests/functions/test_database.py::TestDatabasePostgresPg8000::test_create_and_drop"
    "--deselect tests/functions/test_database.py::TestDatabasePostgresPsycoPG2CFFI::test_create_and_drop"
    "--deselect tests/functions/test_database.py::TestDatabasePostgresPsycoPG3::test_create_and_drop"
  ];

  meta = with lib; {
    changelog = "https://github.com/kvesteri/sqlalchemy-utils/releases/tag/${version}";
    homepage = "https://github.com/kvesteri/sqlalchemy-utils";
    description = "Various utility functions and datatypes for SQLAlchemy";
    license = licenses.bsd3;
    maintainers = with maintainers; [ eadwu ];
  };
}
