{
  description = "My System Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    grub2-themes.url = "github:vinceliuice/grub2-themes";
  };

  outputs = inputs: {
    nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./system/configuration.nix
        inputs.grub2-themes.nixosModules.default
        inputs.home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true; 
          home-manager.useUserPackages = true; 
          home-manager.users.jdoe = { 
            imports = [ ./home/user.nix ];
          }; 
        }
      ];
    };

    homeConfigurations."mrs@nixos" = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = { inherit inputs; };
      modules = [ ./user/home..nix ];
    };
  };
}