{
  description = "Eloy packages overlay";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    overlays = {
      default = final: prev: {
        python3Packages = prev.python3Packages // 
          (import ./utilities.nix final prev).python3Packages //
          (import ./ibm-overlay.nix final prev).python3Packages;
      };
    };
    pkgs = import nixpkgs {
      inherit system;
      overlays = [overlays.default];
    };
  in {
    devShells.x86_64-linux.default = pkgs.mkShell {
      buildInputs = with pkgs.python3Packages; [
        pkgs.python3Packages.prompt-declaration-language
        pkgs.python3Packages.files-to-prompt
      ];
    };
    overlays.default = overlays.default;  # Expose overlays properly here
  };
}
