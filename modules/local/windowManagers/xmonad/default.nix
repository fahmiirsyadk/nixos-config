input@{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.windowManager.fahmi.xmonad;
  xmonad = pkgs.fahmi.xmonad;
  configDir = "xmonad/xmonad-x86_64-linux";
  
in {
  
  imports = [ ./xcompmgr.nix ];

  options.windowManager.fahmi.xmonad = {
    enable = mkEnableOption "Enable fahmi xmonad config";
  };

  config = mkIf cfg.enable {
    environment.variables = {
      "XMONAD_CONFIG_DIR" = "/etc/xmonad";
      "XMONAD_DATA_DIR" = "/etc/xmonad";
      "XMONAD_CACHE_DIR" = "/etc/xmonad";
    };

    environment.etc."${configDir}".source =
      "${xmonad}/bin/xmonad-x86_64-linux";

    environment.etc."xmonad/build" = {
      text = "# This file stops xmonad from recompiling on restart";
      mode = "0774";
    };

    environment.systemPackages = with pkgs; [
      yad
      xdotool
      bottom
      flameshot
      feh
      xorg.xset
      xmonad-log
      nitrogen
      xcompmgr
    ];
    
    services = {
      xserver = {
        enable = true;
        displayManager = {
          #startx.enable = true;
          defaultSession = "none+xmonad";
          lightdm.greeters.mini = {
            enable = true;
            user = "fahmi";
               extraConfig = ''
               [greeter-theme]
               background-image = ""
               background-color = "#0C0F12"
               text-color = "#ff79c6"
               password-background-color = "#1E2029"
               window-color = "#181a23"
               border-color = "#bd93f9"
            '';
          };
        };
        windowManager.xmonad.enable = true;
      };
      fahmi.xcompmgr.enable = true;
    };
  };
}
