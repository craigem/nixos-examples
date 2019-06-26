# This is an example of a basic NixOS configuration file for a Raspberry Pi 3.
# It's best used as your first configuration.nix file and provides ssh, root
# and user accounts as well as Pi 3 specific tweaks.

{ config, pkgs, lib, ... }:

{
  # NixOS wants to enable GRUB by default
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  # For a Raspberry Pi 2 or 3):
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # !!! Needed for the virtual console to work on the RPi 3, as the default of 16M doesn't seem to be enough.
  # If X.org behaves weirdly (I only saw the cursor) then try increasing this to 256M.
  boot.kernelParams = ["cma=32M"];

  # File systems configuration for using the installer's partition layout
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  # !!! Adding a swap file is optional, but strongly recommended!
  swapDevices = [ { device = "/swapfile"; size = 1024; } ];

  hardware.enableRedistributableFirmware = true; # Enable support for Pi firmware blobs

  networking.hostName = "nixosPi";     # Define your hostname.
  networking.wireless.enable = false;  # Toggles wireless support via wpa_supplicant.

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_AU.UTF-8";
  };

  time.timeZone = "Australia/Brisbane"; # Set your preferred timezone:

  # List services that you want to enable:
  services.openssh.enable = true;  # Enable the OpenSSH daemon.

  # Configure users for your Pi:
   users.mutableUsers = false;     # Remove any users not defined in here

  users.users.root = {
    hashedPassword = "$6$eeqJLxwQzMP4l$GTUALgbCfaqR8ut9kQOOG8uXOuqhtIsIUSP.4ncVaIs5PNlxdvAvV.krfutHafrxNN7KzaM7uksr6bXP5X0Sx1";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 Voohu4vei4dayohm3eeHeecheifahxeetauR4geigh9eTheey3eedae4ais7pei4ruv4 me@myhost"
    ];
  };

  # Groups to add
  users.groups.craige.gid = 1000;

  # Define a user account.
  users.users.myusername = {
    isNormalUser = true;
    uid = 1000;
    group = "myusername";
    extraGroups = ["wheel" ];
    hashedPassword = "$6$l2I7i6YqMpeviVy$u84FSHGvZlDCfR8qfrgaP.n7/hkfGpuiSaOY3ziamwXXHkccrOr8Md4V5G2M1KcMJQmX5qP7KOryGAxAtc5T60";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 Voohu4vei4dayohm3eeHeecheifahxeetauR4geigh9eTheey3eedae4ais7pei4ruv4 me@myhost"
    ];
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?
  system.autoUpgrade.enable = true;
  system.autoUpgrade.channel = https://nixos.org/channels/nixos-19.03;
}
