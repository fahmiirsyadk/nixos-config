{ pkgs ? import <nixpkgs> {} }:

with pkgs;
let
  cLibsAndTools = [
    clang
    zlib
    pkg-config
    xorg.libX11
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXScrnSaver
    xorg.libXext
  ];
  xmonad = import ./packages/xmonad pkgs;
  haskellTooling = [
    cabal-install
    ghcid
    haskellPackages.hindent
    haskellPackages.ormolu
    haskellPackages.haskell-language-server
  ];

in mkShell {
  buildInputs = cLibsAndTools ++ haskellTooling ++ [rnix-lsp] ++ [ sumneko-lua-language-server ];
  inputsFrom = [xmonad.env];
  shellHooks = ''
    alias os-build="sudo nixos-rebuild build --flake ."
    alias os-test="sudo nixos-rebuild test --flake ."
    alias os-switch="sudo nixos-rebuild switch --flake ."
  '';
}
