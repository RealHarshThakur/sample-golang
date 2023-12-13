{
  description = "A very basic flake";
  
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs?ref=nixos-23.11";
    };
  };

  outputs = { 
  self, 
  nixpkgs,
  }: let
  system = "aarch64-darwin";
  pkgs = import nixpkgs { inherit system; }; 
  in {
    packages.${system} = {
      mypackage = pkgs.callPackage ./default.nix {
       go_1_20 = pkgs.go_1_20;
      };
      default = self.packages.${system}.mypackage;
    }; 
  };
}
