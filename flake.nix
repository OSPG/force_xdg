{
  description = "force XDG base directory compliance on packages that ignore it";

  outputs = { self, ... }: {
    overlays.default = import ./overlay.nix;

    lib.extend = pkgs: pkgs.extend self.overlays.default;

    nixosModules.default = { ... }: {
      nixpkgs.overlays = [ self.overlays.default ];
    };
  };
}
