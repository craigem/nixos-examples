# Nix configuration for the VMs running Tiny Tiny RSS (TT-RSS)
#
# This file is intended to be imported into a file that defines the host, such
# as tt-rss_vm.nix in this directory. It is for playing with / testing TT-RSS
# and should not be used as an example of a production deployment.
#
# This is very basic TT-RSS setup.

{ config, pkgs, lib, ... }:

{

  services.tt-rss = {
    enable = true;                                # Enable TT-RSS
    database = {                                  # Configure the database
      type = "pgsql";                             # Database type
      password = "tt-rss";                        # Set the database password
    };
    email = {
      fromAddress = "news@mydomain";              # Address for outgoing email
      fromName = "News at mydomain";              # Display name for outgoing email
    };
    selfUrlPath = "http://localhost:18080/";      # Root web URL
    virtualHost = "news.mydomain";                # Setup an Nginx virtualhost
  };

  services.postgresql = {
    enable = true;                # Ensure postgresql is enabled
    authentication = ''
      local tt_rss all ident map=tt_rss-users
    '';
    identMap =                    # Map the tt-rss user to postgresql
      ''
        tt_rss-users tt_rss tt_rss
      '';
  };

  services.nginx = {
    enable = true;                # Enable Nginx
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };

}
