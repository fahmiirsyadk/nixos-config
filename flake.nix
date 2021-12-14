{
  description = "fahmiirsyadk Nix";
  nixConfig.bash-prompt = "> nix-develop $ ";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    nixpkgs-unstable.url = "nixpkgs/master";

    # extras
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager
    , nix-doom-emacs, emacs-overlay, nixos-hardware, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.allowBroken = true;
        overlays = [ emacs-overlay.overlay (import ./packages) ];
      };

      myLib = import ./lib/lib.nix pkgs.lib;
      myModules = myLib.listModulesRec ./modules/local;

    in {
      inherit pkgs;
      inherit myLib;

      devShell.${system} = import ./shell.nix { inherit pkgs; };
      packages.${system} = { xmonad = pkgs.fahmi.xmonad; };

      nixosConfigurations = {
        makima = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs pkgs; };
          modules = pkgs.lib.lists.flatten [
            ./hosts/base
            ./hosts/makima
            ./hosts/makima/hardware-configuration.nix
            myModules
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.fahmi = {
                imports = [
                  nix-doom-emacs.hmModule
                  ./modules/home/services/git.nix
                  ./modules/home/programs/emacs
                ];
              };
            }
          ];
        };
      };
    };
}
