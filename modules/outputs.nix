{
  config,
  inputs,
  ...
}:
let
  workstationModule = import ./nixos/workstation.nix { inherit inputs; };
  laptopModule = config.den.hosts.x86_64-linux.matthisk-laptop-newxos.mainModule;
  desktopModule = config.den.hosts.x86_64-linux.matthisk-desktop-newxos.mainModule;
  matthiskHomeModule = import ./home/matthisk.nix { inherit inputs; };
in
{
  flake = {
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
      localSend = import ./nixos/localsend.nix;
      devMode = import ./nixos/dev-mode.nix;
      nordvpn = import ./nixos/services/nordvpn.nix;
      llmServer = import ./nixos/services/llm-server.nix;
    };

    homeModules = {
      default = matthiskHomeModule;
      matthisk = matthiskHomeModule;
      matthiskBase = import ./home/users-matthisk-base.nix;
      matthiskSsh = import ./home/users-matthisk-ssh.nix;
      git = import ./home/git.nix;
    };

    flakeModules.default = import ./flake-module.nix;
  };
}
