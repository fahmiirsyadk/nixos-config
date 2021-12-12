{ pkgs, ... }:

let
  # Fix any corruptions in the local copy.
  myGitFix = pkgs.writeShellScriptBin "git-fix" ''
    if [ -d .git/objects/ ]; then
      find .git/objects/ -type f -empty | xargs rm -f
      git fetch -p
      git fsck --full
    fi
    exit 1
  '';

in {
  home.packages = [ myGitFix ];

  programs.git = {
    enable = true;
    userName = "fahmiirsyadk";
    userEmail = "fahmiirsyad10@gmail.com";
  };
}
