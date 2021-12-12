{ pkgs, ... }:
  

let
  myEmacs = pkgs.emacsWithPackagesFromUsePackage {
    config = "~/.dotfiles/README.org";
    package = pkgs.emacsGcc;
    alwaysEnsure = true;
    alwaysTangle = true;
  };

in {
  home.packages = [
    pkgs.nitrogen
    pkgs.autorandr
    pkgs.pass
    pkgs.mu
    pkgs.isync
    pkgs.aspell
    pkgs.brightnessctl
    pkgs.nixfmt
  ];   

  programs.emacs = {
     enable = true;
     package = myEmacs;
  };
}
