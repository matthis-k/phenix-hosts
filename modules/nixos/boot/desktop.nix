{ pkgs, ... }:
{
  boot.initrd = {
    systemd.enable = true;
    verbose = false;
  };

  boot.plymouth = {
    enable = true;
    font = "${pkgs.nerd-fonts.hack}/share/fonts/truetype/NerdFonts/Hack/HackNerdFontMono-Regular.ttf";
  };

  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      useOSProber = true;
      default = "saved";
    };
  };

  boot.resumeDevice = "/dev/system/swap";
}
