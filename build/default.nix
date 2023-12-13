{
  lib,
  stdenv,
  buildGoModule,
  ... 
}: buildGoModule {
  name = "my-go-project";

  src = ../.;  

  vendorSha256 = "sha256-0ckBvOAREWI3o+dWBPx957v8AiauKb449kuaGV5CoNg=";

  meta = with lib; {
    description = "My Go Project";
    license = licenses.mit;
  };
}