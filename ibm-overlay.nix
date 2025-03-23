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

    propagatedBuildInputs = with pkgs.python3Packages; [
      pandas
      httpx
      tabulate
      langchain
      importlib-metadata
      lomond
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

    propagatedBuildInputs = with pkgs.python3Packages; [
      pydantic
      httpx
      httpx-sse
      deprecated
      aiolimiter
    ];

    buildInputs = [
      pkgs.python3Packages.poetry-dynamic-versioning
      pkgs.python3Packages.poetry-core
    ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'httpx = "^0.27.0"' 'httpx = ">0.27.0"'
  '';

    doCheck = true;
  };

  alchemy-config = pkgs.python3Packages.buildPythonPackage rec {
    pname = "alchemy-config";
    version = "1.1.3";
    format = "setuptools";
    src = pkgs.python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "sha256-Umrrd80MJ8exEv+2flrxNcQU4y37tKpt/0W1yiSOJW0=";
    };

    preBuild = ''
      echo "PyYAML>=5.3.1" > requirements.txt
    '';

    env = {
      RELEASE_VERSION = version;
    };

    propagatedBuildInputs = [
      pkgs.python3Packages.pyyaml
    ];

    buildInputs = [
      pkgs.python3Packages.setuptools
      pkgs.python3Packages.setuptools-scm
    ];

    doCheck = true;
  };

  granite-io = pkgs.python3Packages.buildPythonPackage rec {
    pname = "granite_io";
    version = "0.2.1";
    pyproject = true;
    src = pkgs.python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "sha256-NZ7AklQdGE7VlZn5O8XGh8mhjFSJLIgU/RFk1x91NrI=";
    };

    propagatedBuildInputs = with pkgs.python3Packages; [
      pydantic
      jsonschema
      nltk
      alchemy-config
    ];

    buildInputs = with pkgs.python3Packages; [
      poetry-dynamic-versioning
      poetry-core
      setuptools
      setuptools-scm
    ];

    doCheck = true;
  };

  prompt-declaration-language = pkgs.python3Packages.buildPythonPackage rec {
    pname = "prompt_declaration_language";
    version = "0.5.0";
    pyproject = true;
    src = pkgs.python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "sha256-OwN+B2Ow3Yb5tuzfYGtothbi802q5KG0W/NisX9X4u4=";
    };

    propagatedBuildInputs = with pkgs.python3Packages; [
      ipython
      jsonschema
      pydantic
      requests
      jinja2
      pyyaml
      termcolor
      python-dotenv
      litellm
      json-repair
      ibm-generative-ai
      granite-io
    ];

    buildInputs = with pkgs.python3Packages; [
      setuptools
      setuptools-scm
    ];
    postPatch = ''
      substituteInPlace pyproject.toml \
        --replace "litellm!=1.59.9,>=1.57.3" "litellm>=1.52.16"
    '';
    doCheck = true;
  };
in
{
  python3Packages = prev.python3Packages // {
    inherit ibm-cos-sdk-core ibm-cos-sdk ibm-watson-ai prompt-declaration-language ibm-generative-ai alchemy-config;
  };
}
