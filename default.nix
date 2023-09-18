{
  lib,
  stdenv,
  buildGoModule,
  go_1_20,
  ... 
}: buildGoModule rec {
  pname = "my-go-project";
  version = "0.1.0";

  src = ./.;  # Update the source directory path

  vendorHash = lib.fakeSha256;

  meta = with lib; {
    description = "My Go Project";
    license = licenses.mit;
  };
}