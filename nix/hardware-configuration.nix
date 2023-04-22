{ config, lib, pkgs, modulesPath, ... }:
{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.supportedFilesystems = [ "ntfs" ];
  boot.initrd.availableKernelModules = [ "ehci_pci" "ata_piix" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  system.fsPackages = [ pkgs.sshfs ];

  
  fileSystems."/data" = 
    { device = "/dev/disk/by-uuid/dfa17d2c-a2a6-489d-ac5b-bf75da211a46";
      fsType = "ext4";
    };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/79c9c731-6b79-4d13-93c5-61f959935dc8";
      fsType = "ext4";
    };

  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-uuid/D419-3E37";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/ac6c99c3-f28b-491c-ae79-cd3a946017ed"; }
    ];


  networking.useDHCP = lib.mkDefault true;
  
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
