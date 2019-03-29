# Configuration for my xmonad desktop requirements

{ config, pkgs, ... }:

{

  services.xserver.enable = true;                        # Enable the X11 windowing system.
  services.xserver.layout = "us";                        # Set your preferred keyboard layout.
  services.xserver.desktopManager.default = "none";      # Unset the default desktop manager.
  services.xserver.windowManager = {                     # Open configuration for the window manager.
    xmonad.enable = true;                                # Enable xmonad.
    xmonad.enableContribAndExtras = true;                # Enable xmonad contrib and extras.
    xmonad.extraPackages = hpkgs: [                      # Open configuration for additional Haskell packages.
      hpkgs.xmonad-contrib                               # Install xmonad-contrib.
      hpkgs.xmonad-extras                                # Install xmonad-extras.
      hpkgs.xmonad                                       # Install xmonad itself.
    ];
    default = "xmonad";                                  # Set xmonad as the default window manager.
  };

  services.xserver.desktopManager.xterm.enable = false;  # Disable NixOS default desktop manager.

  services.xserver.libinput.enable = true;               # Enable touchpad support.

  services.udisks2.enable = true;                        # Enable udisks2.
  services.devmon.enable = true;                         # Enable external device automounting.

  services.xserver.displayManager.sddm.enable = true;    # Enable the default NixOS display manager.
  services.xserver.desktopManager.plasma5.enable = true; # Enable KDE, the default NixOS desktop environment.

  # Install any additional fonts that I require to be used with xmonad
  fonts.fonts = with pkgs; [
    opensans-ttf             # Used in in my xmobar configuration
  ];

  # Install other packages that I require to be used with xmonad.
  environment.systemPackages = with pkgs; [
    dmenu                    # A menu for use with xmonad
    feh                      # A light-weight image viewer to set backgrounds
    haskellPackages.libmpd   # Shows MPD status in xmobar
    haskellPackages.xmobar   # A Minimalistic Text Based Status Bar
    libnotify                # Notification client for my Xmonad setup
    lxqt.lxqt-notificationd  # The notify daemon itself
    mpc_cli                  # CLI for MPD, called from xmonad
    scrot                    # CLI screen capture utility
    trayer                   # A system tray for use with xmonad
    xbrightness              # X11 brigthness and gamma software control
    xcompmgr                 # X composting manager
    xorg.xrandr              # CLI to X11 RandR extension
    xscreensaver             # My preferred screensaver
    xsettingsd               # A lightweight desktop settings server
  ];

}
