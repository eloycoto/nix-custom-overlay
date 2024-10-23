final: prev:
let
  pkgs = prev;

  ibm-cos-sdk-core = pkgs.python3Packages.buildPythonPackage rec {
    pname = "ibm-cos-sdk-core";
    version = "2.13.6";
    pyproject = true;
    src = pkgs.python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "sha256-3UH7eJ7rZVRlAa+rzVDniEarRRO2rUBC5BC2oU/4hBM=";
    };

    buildInputs = with pkgs.python3Packages; [
      setuptools
      jmespath
      dateutil
      requests
    ];

    postPatch = ''
      substituteInPlace setup.py \
        --replace "requests>=2.32.0,<2.32.3" "requests>=2.32.0"
    '';
    doCheck = true;
  };

  ibm-cos-sdk-s3transfer = pkgs.python3Packages.buildPythonPackage rec {
    pname = "ibm-cos-sdk-s3transfer";
    version = "2.13.6";
    pyproject = true;
    src = pkgs.python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "sha256-4KzObzgMR9EeB8Z2W2hLSrq79cZswFA7wkZGmh4rl5A=";
    };

    nativeBuildInputs = with pkgs.python3Packages; [
      poetry-core
    ];

    buildInputs = [
      pkgs.python3Packages.setuptools
      ibm-cos-sdk-core
    ];

    doCheck = true;
  };

  ibm-cos-sdk = pkgs.python3Packages.buildPythonPackage rec {
    pname = "ibm-cos-sdk";
    version = "2.13.6";
    pyproject = true;
    src = pkgs.python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "sha256-Fxzyrkq2YqS4q1jc9KyZSwV31skteEkClf13BKg5ePY=";
    };

    nativeBuildInputs = with pkgs.python3Packages; [
      poetry-core
    ];

    buildInputs = [
      pkgs.python3Packages.setuptools
      pkgs.python3Packages.jmespath
      pkgs.python3Packages.dateutil
      ibm-cos-sdk-core
      ibm-cos-sdk-s3transfer
    ];

    doCheck = true;
  };

  ibm-watson-ai = pkgs.python3Packages.buildPythonPackage rec {
    pname = "ibm_watsonx_ai";
    version = "1.1.16";
    pyproject = true;
    src = pkgs.python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "sha256-q3ntXe3Vf9V0xcbFzspQqJuEI1YmRiVckQ7XSo2IEaU=";
    };

    propagatedBuildInputs = [
      pkgs.python3Packages.pandas
      pkgs.python3Packages.httpx
      pkgs.python3Packages.tabulate
      pkgs.python3Packages.langchain
      pkgs.python3Packages.importlib-metadata
      pkgs.python3Packages.lomond
      ibm-cos-sdk
    ];

    buildInputs = [
      pkgs.python3Packages.setuptools
    ];

    postPatch = ''
      substituteInPlace setup.py \
        --replace "pandas<2.2.0,>=0.24.2"  "pandas==2.2.2"
    '';
    doCheck = true;
  };

  ibm-generative-ai = pkgs.python3Packages.buildPythonPackage rec {
    pname = "ibm_generative_ai";
    version = "3.0.0";
    pyproject = true;
    src = pkgs.python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "sha256-DYYpc3Glu3xB0UOox3DgaPN0ibXKiOa9VtymGk9twag=";
    };

    propagatedBuildInputs = [
      pkgs.python3Packages.pydantic
      pkgs.python3Packages.httpx
      pkgs.python3Packages.httpx-sse
      pkgs.python3Packages.deprecated
      pkgs.python3Packages.aiolimiter
    ];

    buildInputs = [
      pkgs.python3Packages.poetry-dynamic-versioning
      pkgs.python3Packages.poetry-core
    ];

    doCheck = true;
  };

  prompt-declaration-language = pkgs.python3Packages.buildPythonPackage rec {
    pname = "prompt_declaration_language";
    version = "0.0.8";
    pyproject = true;
    src = pkgs.python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "sha256-xgh407gJgemktDlnDW7ViuV9IxPc7P5Ri/vdtKvXAqU=";
    };

    propagatedBuildInputs = [
      pkgs.python3Packages.ipython
      pkgs.python3Packages.jsonschema
      pkgs.python3Packages.pydantic
      pkgs.python3Packages.requests
      pkgs.python3Packages.jinja2
      pkgs.python3Packages.pyyaml
      pkgs.python3Packages.termcolor
      pkgs.python3Packages.python-dotenv
      pkgs.python3Packages.litellm
      ibm-generative-ai
    ];

    buildInputs = [
      pkgs.python3Packages.setuptools
      pkgs.python3Packages.setuptools-scm
    ];

    postPatch = ''
      substituteInPlace pyproject.toml \
        --replace "litellm~=1.49" "litellm>=1.47.0"
    '';
    doCheck = true;
  };
in
{
  python3Packages = prev.python3Packages // {
    inherit ibm-cos-sdk-core ibm-cos-sdk ibm-watson-ai prompt-declaration-language ibm-generative-ai;
  };
}
