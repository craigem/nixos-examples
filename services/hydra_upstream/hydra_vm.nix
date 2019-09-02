# Nix configuration for a VM to run Hydra from master
#
# It is intended as an example of building a VM that builds Hydra from the
# upstream source instead of from nixpkgs.

{ config, pkgs, lib, ... }:

{

  imports =
    [
      ./hydra_notify.nix
    ];

  networking.hostName = "hydra-notications";   # Define your hostname.

  system.stateVersion = "19.03";               # The version of NixOS originally installed
  # Set security options:

  security = {
    sudo = {
      enable = true;                # Enable sudo
      wheelNeedsPassword = false;   # Allow wheel members to run sudo without a passowrd
    };
  };


  # List services that you want to enable:
  services.openssh = {
    enable = true;                             # Enable the OpenSSH daemon.
    #permitRootLogin = "yes";                   # Proably want to change this in production
    #challengeResponseAuthentication = true;    # Proably want to change this in production
    #passwordAuthentication = true;             # Proably want to change this in production
    openFirewall = true;
    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";   # Generate a key for the vm
        type = "ed25519";                         # Use the current best key type
      }
    ];
  };

  # Users of the Hydra VM:
  users.mutableUsers = false;        # Remove any users not defined in here

  users.users.root = {
    password = "123456";   # Proably want to change this in production
  };

  # Misc groups:
  users.groups.nixos.gid = 1000;

  # NixOS users
  users.users.nixos = {
    isNormalUser = true;
    uid = 1000;
    group = "nixos";
    extraGroups = [ "wheel" ];
    password = "123456";   # Proably want to change this in production
  };

}
