{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      ...
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
    in
    flake-utils.lib.eachSystem supportedSystems (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        flake-start = pkgs.callPackage ./default.nix { };
      in
      {
        packages = {
          inherit flake-start;
          default = flake-start;
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            just
            nixfmt
            shfmt
          ];
        };

        apps.default = {
          type = "app";
          program = pkgs.lib.getExe flake-start;
          meta.description = "Run flake-start";
        };

        formatter = pkgs.nixfmt;
      }
    );
}
