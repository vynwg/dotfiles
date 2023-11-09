{ environment, programs, pkgs, ... }:
let 
  nixos2205 = import (builtins.fetchTarball {
    name = "nixos-2023-05-31";
    url = "https://github.com/nixos/nixpkgs/archive/466c2e342a6887507fb5e58d8d29350a0c4b7488.tar.gz";
    sha256 = "0f3pc6rva386ywzh7dig5cppfw5y6kqc6krm5ksl012x3s61bzim";
  }) { config.allowUnfree =  true; };
  unstable = import <unstable> {};
in
{
  environment.variables.EDITOR = "nvim";
  environment.shells = with pkgs; [ fish ];

  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
    elisa
    gwenview
    konsole
    kwallet
    khelpcenter
    kinfocenter
    kwallet-pam
    kwalletmanager
    okular
    oxygen
    print-manager
    plasma-browser-integration
    spectacle
  ];

  users.extraGroups.vboxusers.members = [ "vynwg" ];
  users.users.vynwg = {
    isNormalUser = true;
    description = "Vynwg";
    shell = pkgs.fish;
    extraGroups = [ "audio" "networkmanager" "wheel" "scanner" "lp" ];
    packages = [
      (import ./packages/rustdesk-nightly)
    ] ++ (with pkgs; [
      alacritty
      android-tools
      bottom
      direnv
      droidcam
      easyeffects
      flameshot
      flitter
      freecad
      google-chrome
      gsmartcontrol
      handbrake
      krita
      libqalculate
      libreoffice
      libsForQt5.ktorrent
      neofetch
      nextcloud-client
      obs-studio
      p7zip
      platformio
      prismlauncher
      python2
      python310
      python310Packages.pip
      scrcpy
      spotify
      stellarium
      sublime4
      ttdl
      urn-timer
      vlc
      xorg.libXcursor
      zerotierone
    ]) ++ (with nixos2205; [
      ciscoPacketTracer8
    ]) ++ (with unstable; [
      vesktop
      typst
      typst-live
    ]);
  };

  programs.git.enable = true;
  programs.fish.enable = true;
  programs.dconf.enable = true;
  programs.steam.enable = true;
  programs.neovim.enable = true;

  virtualisation.virtualbox.host.enable = true;

  services.lorri.enable = true;
  services.zerotierone.enable = true;
  services = {
    syncthing = {
        enable = true;
        user = "vynwg";
        dataDir = "/data/Sync";
        configDir = "/home/vynwg/.config/syncthing";
    };
    create_ap = {
      enable = true;
      settings = {
        INTERNET_IFACE = "enp3s0";
        WIFI_IFACE = "wlp4s0";
        SSID = "Vyn";
        PASSPHRASE = "test123321";
      };
    };
  };
}
