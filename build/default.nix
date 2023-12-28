{
  lib,
  stdenv,
  buildGo121Module,
  ... 
}: buildGo121Module {
  name = "github.com/digitalocean/sample-golang";

  src = ../.;  

  vendorHash = "sha256-SAX9JXXAsCr3nkXa7ANduG55Rlqh9XIlkdS644GIj9s=";

  meta = with lib; {
    description = "My Go Project";
    license = licenses.mit;
  };
}