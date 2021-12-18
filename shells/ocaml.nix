{ pkgs ? import <nixpkgs> { } }:

with pkgs;
mkShell {
  buildInputs = [
    ocaml
    ocamlPackages.utop
    ocamlPackages.core
    ocamlPackages.core_extended
    ocamlPackages.core_bench
    ocamlPackages.cohttp-async
    ocamlPackages.async
    ocamlPackages.cryptokit
    ocamlPackages.menhir
  ];
  shellHook = ''
  '';
}
