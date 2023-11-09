{ lib, boot, programs, config, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ./user.nix
      ./rustdesk_service.nix
    ];

  nixpkgs.overlays = [
    ( import ./overlays/chrome.nix )
    ( import ./overlays/ciscoPacketTracer8.nix )
  ];

  nixpkgs.config.permittedInsecurePackages = [
  #  "electron-21.4.0"
    "openssl-1.1.1w"
    "python-2.7.18.6"
  ];

  # Firmware
  hardware.enableAllFirmware = true;
  hardware.firmware = [ pkgs.alsa-firmware ];

  
  # Hardware video
  hardware.opengl.enable = true;
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;


  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_6_1;
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelModules = [ "v4l2loopback" "snd-aloop" ];
  boot.extraModulePackages = [ pkgs.linuxKernel.packages.linux_zen.v4l2loopback ];
  boot.extraModprobeConfig =
    ''
    options v4l2loopback nr_devices=2 exclusive_caps=1,1 video_nr=0,1 card_label=v4l2lo0,v4l2lo1
    '';


  # Misc
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.pulseaudio = true;
  # security.rtkit.enable = true;
  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "-d";
  };

  # Network configuration
  networking.hostName = "nixos";
  networking.wireless.enable = true;
  networking.wireless.userControlled.enable = true;
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;


  # Firewall
  # networking.firewall.allowedTCPPorts = [ ];
  # networking.firewall.allowedUDPPorts = [ ];
  networking.firewall.enable = false;
  # networking.firewall.allowPing = true;


  # Xserver settings
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Timezone and locale configuration
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };
  services.xserver = {
    layout = "br";
    xkbModel = "pc104";
    xkbVariant = "";
    xkbOptions = "terminate:ctrl_alt_bksp,numpad:microsoft,grp:win_space_toggle";
  };
  console.keyMap = "br-abnt2";


  # Printer setup
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplip ];
  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.hplipWithPlugin ];


  # Sound setup
  sound.enable = true;
  # hardware.pulseaudio.enable = true;
  # hardware.pulseaudio.support32Bit = true;
  # hardware.pulseaudio.package = pkgs.pulseaudioFull;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  system.stateVersion = "23.05";
}
