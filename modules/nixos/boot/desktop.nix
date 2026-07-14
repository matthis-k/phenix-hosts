{ pkgs, ... }:
{
  boot = {
    initrd = {
      systemd.enable = true;
      verbose = false;
    };

    plymouth = {
      enable = true;
      font = "${pkgs.nerd-fonts.hack}/share/fonts/truetype/NerdFonts/Hack/HackNerdFontMono-Regular.ttf";
    };

    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        useOSProber = true;
        default = "saved";
      };
    };

    resumeDevice = "/dev/system/swap";
  };
}
