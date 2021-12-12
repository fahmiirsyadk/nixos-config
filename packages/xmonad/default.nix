{ pkgs, ...}: pkgs.haskell.packages.ghc8107.callCabal2nix "xmonad" ./. { }
