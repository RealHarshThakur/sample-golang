{
  description = "A very basic flake";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: let
    supportedSystems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" "aarch64-linux" ];
    forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
      pkgs = import nixpkgs { inherit system; };
    });
  in {
    packages = forEachSupportedSystem ({ pkgs }: {
      default = pkgs.callPackage ./default.nix {
        go_1_21 = pkgs.go_1_21;
      };
    });

    devShells = forEachSupportedSystem ({ pkgs }: {
      devShell = pkgs.mkShell {
        # The Nix packages provided in the environment
        packages = with pkgs; [
          go_1_19 # Go 1.19
          gotools # Go tools like goimports, godoc, and others
        ];
      };
    });

    runtimeEnvs = forEachSupportedSystem ({ pkgs }: {
      runtime = pkgs.buildEnv {
        name = "runtimeenv";
        paths = with pkgs; [ bash curl ];
      };
    });
  };
}
