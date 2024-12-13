{
  description = "Eloy packages overlay";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    overlays = {
      default = import ./ibm-overlay.nix;
    };
    pkgs = import nixpkgs {
      inherit system;
      overlays = [overlays.default];
    };
  in {
    devShells.x86_64-linux.default = pkgs.mkShell {
      buildInputs = with pkgs.python3Packages; [
        pkgs.python3Packages.prompt-declaration-language
      ];
    };
    overlays.default = overlays.default;  # Expose overlays properly here
  };
}
