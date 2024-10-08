{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  six,
  html5lib,
  setuptools,
  tinycss2,
  packaging,
  pythonOlder,
  webencodings,
}:

buildPythonPackage rec {
  pname = "bleach";
  version = "6.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CjHxg3ljxB1Gu/EzG4d44TCOoHkdsDzE5zV7l89CqP4=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    html5lib
    packaging
    setuptools
    six
    webencodings
  ];

  optional-dependencies = {
    css = [ tinycss2 ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Disable network tests
    "protocols"
  ];

  pythonImportsCheck = [ "bleach" ];

  meta = with lib; {
    description = "Easy, HTML5, whitelisting HTML sanitizer";
    longDescription = ''
      Bleach is an HTML sanitizing library that escapes or strips markup and
      attributes based on a white list. Bleach can also linkify text safely,
      applying filters that Django's urlize filter cannot, and optionally
      setting rel attributes, even on links already in the text.

      Bleach is intended for sanitizing text from untrusted sources. If you
      find yourself jumping through hoops to allow your site administrators
      to do lots of things, you're probably outside the use cases. Either
      trust those users, or don't.
    '';
    homepage = "https://github.com/mozilla/bleach";
    downloadPage = "https://github.com/mozilla/bleach/releases";
    changelog = "https://github.com/mozilla/bleach/blob/v${version}/CHANGES";
    license = licenses.asl20;
    maintainers = with maintainers; [ prikhi ];
  };
}
