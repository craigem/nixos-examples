# Configuration for my wireless networking requirements
#
# This example assumes that have run
# wpa_passphrase exampleSSID abcd1234
# to obtain the raw PSK.

{ config, pkgs, ... }:

{

  networking.wireless = {
    enable = true;                # Enables wireless support via wpa_supplicant.
    userControlled.enable = true;
    networks = {
      exampleSSID = {             # A more common style of SSID
        pskRaw = "46c25aa68ccb90945621c1f1adbe93683f884f5f31c6e2d524eb6b446642762d";
      };
      "example's SSID" = {        # Connect to an SSID with spaces and punctuation characters
        pskRaw = "46c25aa68ccb90945621c1f1adbe93683f884f5f31c6e2d524eb6b446642762d";
      };
      myHiddenSSID = {            # An example of how to connect to a hidden SSID.
        hidden = true;
        pskRaw = "46c25aa68ccb90945621c1f1adbe93683f884f5f31c6e2d524eb6b446642762d";
      FreeWiFi = {};              # An example of how to connect to an open SSID.
      };
    };
  };

}
