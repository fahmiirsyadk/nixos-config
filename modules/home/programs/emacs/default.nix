
  
{ pkgs, ... }: {
  
  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./.doom.d;
    emacsPackage = pkgs.emacsGcc;
    extraPackages = with pkgs; [
      mu
      # tools for Nix
      nixfmt
      nixpkgs-fmt
      fd
      ripgrep
      jq
      shellcheck
      isync
      rubocop
      # tools for OCaml
      dune-release
      ocamlformat
      # tools for python
      (python38.withPackages(ps: with ps; [jupyter]))
      # tools for haskell
      ghc
      #haskellPackages.hls
      # tools for nodeJS
      nodejs
      nodePackages.yarn
      # shell
      shfmt
      shellcheck
      # spellcheck
      ispell
      (aspellWithDicts (dicts: with dicts; [ en en-computers en-science ]))
    ] ++ ( with ocamlPackages;
    [
      ocaml
      core
      core_extended
      findlib
      utop
      merlin
      ocp-indent
      ocaml-lsp
    ]);
  };
}
