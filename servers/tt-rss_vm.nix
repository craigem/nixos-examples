# Nix configuration for a VM to run Tiny Tiny RSS (TT-RSS)
#
# It is intended as an example of building a VM that builds TT-RSS for testing
# and evaluation purposes. I does not represent a production or secure
# deployment.

{ config, pkgs, lib, ... }:

{

  imports =
    [
      ./tt-rss_for_VM_testing.nix
    ];

  networking.hostName = "tt-rss";   # Define your hostname.

  system.stateVersion = "19.03";    # The version of NixOS originally installed

  # Set security options:
  security = {
    sudo = {
      enable = true;                # Enable sudo
      wheelNeedsPassword = false;   # Allow wheel members to run sudo without a passowrd
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 ];

  # List services that you want to enable:
  services.openssh = {
    enable = true;                             # Enable the OpenSSH daemon.
    #permitRootLogin = "yes";                  # Probably want to change this in production
    #challengeResponseAuthentication = true;   # Probably want to change this in production
    #passwordAuthentication = true;            # Probably want to change this in production
    openFirewall = true;
    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";   # Generate a key for the vm
        type = "ed25519";                         # Use the current best key type
      }
    ];
  };

  # Users of the TT-RSS VM:
  users.mutableUsers = false;        # Remove any users not defined in here

  users.users.root = {
    password = "123456";             # Probably want to change this in production
  };

  # Misc groups:
  users.groups.nixos.gid = 1000;

  # NixOS users
  users.users.nixos = {
    isNormalUser = true;
    uid = 1000;
    group = "nixos";
    extraGroups = [ "wheel" ];
    password = "123456";             # Probably want to change this in production
  };

}
