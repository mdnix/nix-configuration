{
  description = "Marco's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    sops-nix.url = "github:Mic92/sops-nix";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";

    stylix.url = "github:danth/stylix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, disko, nixos-hardware, hyprland, hyprpanel, stylix, ... }@inputs: {
    nixosConfigurations = {
      x1 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          {
            nixpkgs.overlays = [
              (import ./overlays { inherit inputs; }).additions
              (import ./overlays { inherit inputs; }).modifications
              (import ./overlays { inherit inputs; }).unstable-packages
            ];
            _module.args = { inherit inputs; };
          }

          # Hardware configuration
          nixos-hardware.nixosModules.lenovo-thinkpad-x1-13th-gen

          # Core modules
          ./hosts/x1/configuration.nix

          # Home manager
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.marco = import ./modules/home-manager;
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };

      testvm = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          {
            nixpkgs.overlays = [
              (import ./overlays { inherit inputs; }).additions
              (import ./overlays { inherit inputs; }).modifications
              (import ./overlays { inherit inputs; }).unstable-packages
            ];
            _module.args = { inherit inputs; };
          }

          # Core modules
          ./hosts/testvm/configuration.nix

          # Home manager
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.marco = import ./modules/home-manager;
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };
    };
  };
}

