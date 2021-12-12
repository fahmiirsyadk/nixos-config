{ pkgs, lib, config, ... }: {
  users.users.fahmi = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
    shell = pkgs.bash;
  };

  nixpkgs.config.pulseaudio = true;

  services.xserver.enable = true;

  networking = {
    useDHCP = false;
    interfaces.enp7s0.useDHCP = true;
    interfaces.wlp0s20f3.useDHCP = true;
    networkmanager.enable = true;
  }; 
 
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 10;
      systemd-boot.enable = true;
      grub.useOSProber = true;
    };
  };


  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  time.timeZone = "Asia/Jakarta";
  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    cachix
    pciutils
    ispell
    w3m
    wget
    nnn
  ];

  sound.enable = true;
  hardware.bluetooth.enable = true;
  hardware.pulseaudio = {
    enable = true;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
    package = pkgs.pulseaudioFull;
  };

  nix = {
    gc = {
      automatic = true;
      dates = "monthly";
      options = "--delete-older-than 90d";
    };
    autoOptimiseStore = true;
    trustedUsers = ["fahmi" "root"];
    
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
