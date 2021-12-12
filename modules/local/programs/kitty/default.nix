{ config, lib, pkgs, ... }:

with lib;
let cfg = config.programs.fahmi.kitty;
in {
  options.programs.fahmi.kitty = {
    enable = mkEnableOption "Enable Kitty";
    extraConfig = mkOption {
      type = lib.types.lines;
      default = '''';
    };
  };

  config = mkIf cfg.enable {
    fonts.fonts = with pkgs; [
      jetbrains-mono
    ];

    environment.systemPackages = 
      let 
        config = pkgs.writeText "kitty config" (
          (builtins.readFile ./config/kitty.conf) +
          cfg.extraConfig
        );

        wrapped = pkgs.writeShellScriptBin "kitty" ''
          exec ${pkgs.kitty}/bin/kitty -c ${config}
        '';

        package = pkgs.symlinkJoin {
          name = "kitty";
          paths = [
            wrapped
            pkgs.kitty
          ];
        };
      in
      [ package ];
  };
}
