# NixOS configuration for Android development environment

{ config, pkgs, ... }:

{

  nixpkgs.config = {
    android_sdk.accept_license = true;   # Accept the Android SDK licence
  };

  programs.adb.enable = true;            # Enable Android Debug Bridge

  # Install other packages that are required to be used with Android.
  environment.systemPackages = with pkgs; [
    gitRepo    # Android's repo management tool
    heimdall   # Needed to work with Samsung devices
  ];

  users.groups.adbusers.members = [
    "myUserName"
  ];

}
