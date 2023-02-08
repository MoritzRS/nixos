{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    grub2-themes = {
      url = "github:vinceliuice/grub2-themes";
    };
  };

  outputs = inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        inputs.home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
        }
        inputs.grub2-themes.nixosModules.default
      ];
    };
  };
}