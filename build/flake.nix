{
  description = "A very basic flake";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nix2container.url = "github:nlewo/nix2container";
  };

  outputs = inputs@ { self, nixpkgs, nix2container }: let
    supportedSystems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" "aarch64-linux" ];
    forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
      pkgs = import nixpkgs { inherit system; };
      nix2containerPkgs = nix2container.packages.${system};
      inherit system;
    });

  in {
    packages = forEachSupportedSystem ({ pkgs, nix2containerPkgs,...   }: {
      default = pkgs.callPackage ./default.nix {
        go = pkgs.go;
      };
    });

    devShells = forEachSupportedSystem ({ pkgs,nix2containerPkgs, ...  }: {
      devShell = pkgs.mkShell {
        # The Nix packages provided in the environment
        packages =  [
          pkgs.gotools
        ];
      };
    });


    
   configs = forEachSupportedSystem({pkgs,...}:{
      config = pkgs.stdenvNoCC.mkDerivation {
      name = "copy-config";
      src = ../.;
      phases = [ "unpackPhase" "installPhase" ];
      installPhase = ''
        mkdir -p $out
        mkdir -p $out/tmp
        cp -r $src/go.mod $out
        cp -r $src/cmd $out
      '';
   };
   });


   runtimeEnvs = forEachSupportedSystem ({ pkgs, nix2containerPkgs,...  }: {
      runtime = pkgs.buildEnv {
        name = "runtimeenv";
        paths =  [ pkgs.bash
         pkgs.curl 
         pkgs.coreutils
        ];
      };
    });

   ociImages = forEachSupportedSystem ({ pkgs, nix2containerPkgs, system ,...}: {

    ociImage =  nix2containerPkgs.nix2container.buildImage {

    name = "hello";
      config = {
      # entrypoint = ["${inputs.self.packages.${system}.default}/bin/my-go-project"];
      cmd = ["${inputs.self.packages.${system}.default}/bin/my-go-project"];
      };
     maxLayers = 100;
     layers = [
         (nix2containerPkgs.nix2container.buildLayer { 
            copyToRoot = [
            inputs.self.runtimeEnvs.${system}.runtime
            inputs.self.configs.${system}.config
          ];
         })
      ];

    

};
   ociImage-as-dir = pkgs.runCommand "image-as-dir" { } "${inputs.self.ociImages.${system}.ociImage.copyTo}/bin/copy-to dir:$out";
   });

  };
}
