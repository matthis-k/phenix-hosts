{
  den,
  inputs,
  lib,
  ...
}:
let
  workstationModule = import ./nixos/workstation.nix { inherit inputs; };
  laptopModule = import ./nixos/hosts/laptop.nix;
  desktopModule = import ./nixos/hosts/desktop.nix;
  matthiskHostModule = import ./nixos/users-matthisk.nix { inherit inputs; };
  matthiskHomeModule = import ./home/matthisk.nix { inherit inputs; };
in
{
  den = {
    schema.user.classes = lib.mkDefault [ "homeManager" ];

    hosts.x86_64-linux = {
      matthisk-laptop-newxos.users.matthisk = { };
      matthisk-desktop-newxos.users.matthisk = { };
    };

    aspects = {
      workstation.nixos = workstationModule;

      matthisk-laptop-newxos = {
        includes = [ den.aspects.workstation ];
        nixos = laptopModule;
      };

      matthisk-desktop-newxos = {
        includes = [ den.aspects.workstation ];
        nixos = desktopModule;
      };

      matthisk = {
        homeManager = matthiskHomeModule;
        provides.to-hosts.nixos = matthiskHostModule;
      };
    };
  };
}
