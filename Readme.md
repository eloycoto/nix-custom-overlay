# Flake utils repo

how to use:

```
{
  description = "Test environment";
  inputs = {
    your-overlay.url = "path:../packages-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, your-overlay }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [ your-overlay.overlays.default ];
    };
  in {
    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        python3Packages.ibmWatsonAI
      ];
    };
  };
}
```
