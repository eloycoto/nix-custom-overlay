final: prev:
let
  pkgs = prev;

  files-to-prompt = pkgs.python3Packages.buildPythonPackage rec {
    pname = "files-to-prompt";
    version = "0.6";
    pyproject = true;
    src = pkgs.python3Packages.fetchPypi {
      pname = "files_to_prompt";
      inherit version;
      sha256 = "sha256-mvV+7L2ynTzOA0wYZJP/xsEgXqT1q95vsyzLHZbq5Aw=";
    };

    buildInputs = with pkgs.python3Packages; [
      setuptools
    ];

    propagatedBuildInputs = [
      pkgs.python3Packages.click
    ];

    doCheck = true;
  };
in
{
  python3Packages = prev.python3Packages // {
    inherit files-to-prompt;
  };
}
