{ config, pkgs, lib, ... }: {

  networking.hostName = "makima";
  networking.extraHosts = import ./hosts.nix;

  nixpkgs.config.allowUnfree = true;

  programs.fahmi.kitty.enable = true;
  programs.fahmi.bash.enable = true;
  programs.fahmi.bash.starship.enable = true;
  # programs.fahmi.emacs.enable = true;
  # programs.fahmi.emacs.package = pkgs.emacsGcc;

  windowManager.fahmi.xmonad.enable = true;
  services.xserver.layout = "us";
  services.xserver.libinput.enable = true;
  services.fstrim.enable = true;

  users.users.fahmi.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBECGcPRf/67D8EHQDsnCiAEOh0QaMwKD9BHwKzecH9C fahmiirsyad10@gmail.com"
  ];

  fonts.fonts = with pkgs; [
    etBook
    google-fonts
    hack-font
    jetbrains-mono
    victor-mono
    oldstandard
    gyre-fonts
    libre-baskerville
    siji
    cm_unicode
    bakoma_ttf
    lmmath
  ];

  fonts.fontconfig = {
    enable = true;
    antialias = true;
    hinting = { enable = true; };
  };

  environment.systemPackages = with pkgs; [
    zathura
    maxima
    google-chrome
    wxmaxima
    texlive.combined.scheme-full
    libreoffice
    firefox
    playerctl
    gsettings-desktop-schemas
    gnumake
    neofetch
    mpc_cli
    mpv
    xfce.thunar
    discord
    gnome.gucharmap
    rofi-pass
    ncspot
    neovim
    dmenu
    pavucontrol
    man-pages
    scrot
    nixfmt
  ];
  system.stateVersion = "21.11";
}
