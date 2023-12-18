{ environment, programs, pkgs, ... }:
let
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
    extraGroups = [ "audio" "networkmanager" "wheel" "scanner" "lp" "dialout" ];
    packages = (with pkgs; [
      alacritty
      android-tools
      bottom
      direnv
      droidcam
      easyeffects
      flameshot
      freecad
      gamemode
      google-chrome
      gsmartcontrol
      handbrake
      krita
      libqalculate
      libreoffice
      libsForQt5.ktorrent
      neofetch
      obs-studio
      p7zip
      platformio
      prismlauncher
      python2
      python310
      python310Packages.pip
      rustdesk
      scrcpy
      spotify
      sublime4
      vlc
      xorg.libXcursor
      zerotierone
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
