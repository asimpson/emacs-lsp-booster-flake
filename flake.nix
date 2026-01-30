{
  description = "A flake for ghub:blahgeek/emacs-lsp-booster";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-compat = {
      url = "github:NixOS/flake-compat";
      flake = false;
    };
  };

  outputs = { nixpkgs, ... }:
    let overlay = final: prev: {
          emacs-lsp-booster = final.callPackage ./package.nix { };
        };
        supportedSystems = [ "aarch64-linux" "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
        forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
        nixpkgsFor = forAllSystems (system:
          import nixpkgs {
            inherit system;
            overlays = [ overlay ];
          });
    in {
      overlays.default = overlay;

      packages = forAllSystems (system: {
        default = nixpkgsFor.${system}.emacs-lsp-booster;
      });
    };
}
