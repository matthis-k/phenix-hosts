{
  boot = {
    initrd.systemd.enable = true;
    plymouth.enable = true;

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
