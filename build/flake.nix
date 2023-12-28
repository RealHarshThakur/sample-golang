{
  description = "A very basic flake";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-a89.url = "github:nixos/nixpkgs/a89ba043dda559ebc57fc6f1fa8cf3a0b207f688";
  };

  outputs = { self, nixpkgs, nixpkgs-a89, }: let
    supportedSystems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" "aarch64-linux" ];
    forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
      pkgs = import nixpkgs { inherit system; };
      nixpkgs-a89-pkgs = import nixpkgs-a89 { inherit system; };
    });

  in {
    packages = forEachSupportedSystem ({ pkgs, nixpkgs-a89-pkgs }: {
      default = pkgs.callPackage ./default.nix {
        go = pkgs.go;
      };
    });

    devShells = forEachSupportedSystem ({ pkgs, nixpkgs-a89-pkgs }: {
      devShell = pkgs.mkShell {
        # The Nix packages provided in the environment
        packages =  [
          nixpkgs-a89-pkgs.go_1_20 
          pkgs.gotools
        ];
      };
    });

    runtimeEnvs = forEachSupportedSystem ({ pkgs, nixpkgs-a89-pkgs }: {
      runtime = pkgs.buildEnv {
        name = "runtimeenv";
        paths =  [ pkgs.bash
         pkgs.curl 
        ];
      };
    });
  };
}
