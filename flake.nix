{
  description = "Eloy packages overlay";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };


  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      # Import nixpkgs and apply the overlay
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ (import ./ibm-overlay.nix) ];  # Apply the overlay here
      };
    in {
      devShells.x86_64-linux.default = pkgs.mkShell {
        buildInputs = with pkgs.python3Packages; [
          pkgs.python3Packages.prompt-declaration-language
        ];
      };
    };
}
