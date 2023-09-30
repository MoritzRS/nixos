{
  description = "NixOS System Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    grub2-themes.url = "github:vinceliuice/grub2-themes";
    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: {
    nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./config/system.nix
        inputs.grub2-themes.nixosModules.default
        inputs.home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true; 
          home-manager.useUserPackages = true; 
          home-manager.users.mrs = { 
            imports = [ ./config/home.nix ];
          }; 
        }
      ];
    };
  };
}