{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = inputs.nixpkgs.lib.systems.flakeExposed;

      perSystem = { self', lib, pkgs, ... }:
        {
          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              go_1_21
              oapi-codegen
              just
            ];
          };

          packages = {
            default = pkgs.buildGoModule {
              name = "api-testing";
              src = ./.;
              subPackages = [ "cmd/api-testing" ];
              vendorHash = "sha256-nS1eraMNDhiJcBDF0vVnxlcWb5PgpB1p4JDPV2MzP5Q=";
            };

            docker = pkgs.dockerTools.buildImage {
              name = "api-testing-server";
              tag = "latest";
              created = "now";
              copyToRoot = pkgs.buildEnv {
                name = "api-testing-server";
                paths = [ self'.packages.default ];
                pathsToLink = [ "/bin" ];
              };
              config = {
                Cmd = [ "/bin/api-testing" ];
              };
            };

            client = pkgs.buildGoModule {
              name = "api-testing-client";
              src = ./pkg/client;
              vendorHash = null;
            };
          };
        };
    };
}
