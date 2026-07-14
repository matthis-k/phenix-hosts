{
  config,
  inputs,
  ...
}:
let
  workstationModule = import ./nixos/workstation.nix { inherit inputs; };
  laptopModule = config.den.hosts.x86_64-linux.matthisk-laptop-phenix.mainModule;
  desktopModule = config.den.hosts.x86_64-linux.matthisk-desktop-phenix.mainModule;
  matthiskHostModule = import ./nixos/users-matthisk.nix;
  matthiskHomeModule = import ./home/matthisk.nix { inherit inputs; };
  sopsModule = import ./nixos/sops.nix { inherit inputs; };
  standaloneMatthiskModule = {
    imports = [
      sopsModule
      matthiskHostModule
    ];
  };
in
{
  flake = {
    nixosModules = {
      default = workstationModule;
      workstation = workstationModule;
      laptop = laptopModule;
      desktop = desktopModule;
      homeManager = import ./nixos/home-manager.nix { inherit inputs; };
      sops = sopsModule;
      nix = import ./nixos/nix-base.nix { inherit inputs; };
      userMatthisk = standaloneMatthiskModule;
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
