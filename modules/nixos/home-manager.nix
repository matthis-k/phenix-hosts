{ inputs }:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    useGlobalPkgs = false;
    useUserPackages = true;
  };
}
