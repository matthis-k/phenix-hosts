{ inputs, ... }:
let
  workstationModule = import ./nixos/workstation.nix { inherit inputs; };
  laptopModule = import ./nixos/hosts/laptop.nix { inherit inputs; };
  desktopModule = import ./nixos/hosts/desktop.nix { inherit inputs; };
  matthiskHomeModule = import ./home/matthisk.nix { inherit inputs; };

  mkSystem = module: inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs; };
    modules = [ module ];
  };
in
{
  flake = {
    nixosConfigurations = {
      matthisk-laptop-newxos = mkSystem laptopModule;
      matthisk-desktop-newxos = mkSystem desktopModule;
    };

    nixosModules = {
      default = workstationModule;
      workstation = workstationModule;
      laptop = laptopModule;
      desktop = desktopModule;
      homeManager = import ./nixos/home-manager.nix { inherit inputs; };
      sops = import ./nixos/sops.nix { inherit inputs; };
      nix = import ./nixos/nix-base.nix { inherit inputs; };
      userMatthisk = import ./nixos/users-matthisk.nix { inherit inputs; };
      locale = import ./nixos/locale-de-en.nix;
      audio = import ./nixos/audio-pipewire.nix;
      sudo = import ./nixos/sudo-wheel-passwordless.nix;
      networking = import ./nixos/networking.nix;
      localSend = import ./nixos/localsend.nix { inherit inputs; };
      devMode = import ./nixos/dev-mode.nix;
      nordvpn = import ./nixos/services/nordvpn.nix { inherit inputs; };
      llmServer = import ./nixos/services/llm-server.nix;
    };

    homeModules = {
      default = matthiskHomeModule;
      matthisk = matthiskHomeModule;
      matthiskBase = import ./home/users-matthisk-base.nix;
      matthiskSsh = import ./home/users-matthisk-ssh.nix;
      git = import ./home/git.nix;
    };
  };
}
