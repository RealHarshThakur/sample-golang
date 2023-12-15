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

      devShells = pkgs.mkShell {
         packages = with pkgs; [
            go_1_19 # Go 1.19
            gotools # Go tools like goimports, godoc, and others
            redis
          ];
      };

      runtimeEnv = pkgs.buildEnv {
        name = "my-env";
        paths = with pkgs; [ bash curl  ];
      };

    }; 
  };
}
