{
  den,
  inputs,
  lib,
  ...
}:
let
  inventory = import ./inventory.nix;
  laptop = inventory.hosts.laptop;
  desktop = inventory.hosts.desktop;

  workstationModule = import ./nixos/workstation.nix { inherit inputs inventory; };
  laptopModule = import ./nixos/hosts/laptop.nix { host = laptop; };
  desktopModule = import ./nixos/hosts/desktop.nix { host = desktop; };
  matthiskHostModule = import ./nixos/users-matthisk.nix;
  matthiskHomeModule = import ./home/matthisk.nix { inherit inputs inventory; };
in
{
  den = {
    schema.user.classes = lib.mkDefault [ "homeManager" ];

    hosts.x86_64-linux = {
      ${laptop.hostName} = {
        users.${inventory.primaryUser} = { };
      };
      ${desktop.hostName} = {
        users.${inventory.primaryUser} = { };
      };
    };

    aspects = {
      workstation.nixos = workstationModule;

      ${laptop.hostName} = {
        includes = [ den.aspects.workstation ];
        nixos = laptopModule;
      };

      ${desktop.hostName} = {
        includes = [ den.aspects.workstation ];
        nixos = desktopModule;
      };

      ${inventory.primaryUser} = {
        homeManager = matthiskHomeModule;
        provides.to-hosts.nixos = matthiskHostModule;
      };
    };
  };
}
