{
  config,
  inputs,
  ...
}:
let
  inventory = import ./inventory.nix;
  laptop = inventory.hosts.laptop;
  desktop = inventory.hosts.desktop;

  contextModule = import ./nixos/context.nix { inherit inventory; };
  workstationModule = import ./nixos/workstation.nix {
    inherit inputs inventory;
  };
  laptopModule = config.den.hosts.x86_64-linux.${laptop.hostName}.mainModule;
  desktopModule = config.den.hosts.x86_64-linux.${desktop.hostName}.mainModule;
  matthiskHostModule = import ./nixos/users-matthisk.nix;
  matthiskHomeModule = import ./home/matthisk.nix {
    inherit inputs inventory;
  };
  homeContextModule = import ./home/context.nix { inherit inventory; };
  sopsModule = import ./nixos/sops.nix { inherit inputs; };
  standaloneMatthiskModule = {
    imports = [
      contextModule
      sopsModule
      matthiskHostModule
    ];
  };
  standaloneHomeModule = module: {
    imports = [
      homeContextModule
      module
    ];
  };
in
{
  flake = {
    nixosModules = {
      default = workstationModule;
      workstation = workstationModule;
      context = contextModule;
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
      context = homeContextModule;
      matthisk = matthiskHomeModule;
      matthiskBase = standaloneHomeModule (import ./home/users-matthisk-base.nix);
      matthiskSsh = standaloneHomeModule (import ./home/users-matthisk-ssh.nix { inherit inventory; });
      git = standaloneHomeModule (import ./home/git.nix);
    };

    flakeModules.default = import ./flake-module.nix;
  };
}
