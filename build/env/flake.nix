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
      packages.${system}.default = pkgs.buildEnv {
        name = "my-env";
        paths = with pkgs; [ curl go_1_20 ];
      };
  };
}
