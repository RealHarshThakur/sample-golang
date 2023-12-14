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
      packages.${system}.default = pkgs.buildEnv {
        name = "my-env";
        paths = with pkgs; [ bash curl go_1_21 ];
      };
  };
}
