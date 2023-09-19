{
  lib,
  stdenv,
  buildGoModule,
  go_1_20,
  ... 
}: buildGoModule rec{
  name = "my-go-project";

  src = ./.;  # Update the source directory path

  vendorSha256 = "sha256-pQpattmS9VmO3ZIQUFn66az8GSmB4IvYhTTCFn6SUmo=";

  meta = with lib; {
    description = "My Go Project";
    license = licenses.mit;
  };
}