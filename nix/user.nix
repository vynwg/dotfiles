{ environment, programs, pkgs, ... }:
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
  ];

  users.users.vynwg = {
    isNormalUser = true;
    description = "Vynwg";
    shell = pkgs.fish;
    extraGroups = [ "audio" "networkmanager" "wheel" ];
    packages = [
      (import ./packages/rustdesk-nightly)
    ] ++ (with pkgs; [
      alacritty
      direnv
      discord
      google-chrome
      handbrake
      krita
      libreoffice
      libsForQt5.ktorrent
      neofetch
      obsidian
      obs-studio
      p7zip
      prismlauncher
      python39
      revolt-desktop
      # rustdesk
      # shutter
      spotify
      sublime4
      vlc
      zerotierone
      warzone2100
    ]);
  };

  programs.git.enable = true;
  programs.fish.enable = true;
  programs.steam.enable = true;
  programs.neovim.enable = true;

  services.lorri.enable = true;
  services.zerotierone.enable = true;
}