{
  description = "A very basic flake";
  
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs?ref=nixos-unstable";
    };
  };

  outputs = { 
  self, 
  nixpkgs,
  }: let
  system = "aarch64-linux";
  pkgs = import nixpkgs { inherit system; }; 
  in {
    packages.${system} = {
      mypackage = pkgs.callPackage ./default.nix {
       go_1_21 = pkgs.go_1_21;
      };
      default = self.packages.${system}.mypackage;
    }; 
  };
}
