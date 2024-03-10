{
  description = "Race Protocol on Sui blockchain";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
    sui-overlay = {
      url = "github:DogLooksGood/sui-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs = { self, nixpkgs, flake-utils, sui-overlay }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ sui-overlay.overlays.${system}.default ];
        pkgs = import nixpkgs { inherit system overlays; };
      in
        with pkgs;
        {
          devShell = mkShell {
            buildInputs = [
              sui-devnet # or sui-testnet, sui-mainnet
              just
              nodejs_20
              nodePackages.pnpm
            ];
            RUST_LOG="info,sui_node=info";
          };
        }
    );
}
