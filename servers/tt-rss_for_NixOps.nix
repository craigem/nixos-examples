# NixOps configuration for the hosts running Tiny Tiny RSS (TT-RSS)
#
# Will need to be used with an appropriate secrets file. See: ../secrets.nix

{ config, pkgs, lib, ... }:

{

  services.tt-rss = {
    enable = true;                                # Enable TT-RSS
    database = {                                  # Configure the database
      type = "pgsql";                             # Database type
      passwordFile = "/run/keys/tt-rss-dbpass";   # Where to find the password
    };
    email = {
      fromAddress = "news@mydomain";              # Address for outgoing email
      fromName = "News at mydomain";              # Display name for outgoing email
    };
    selfUrlPath = "https://news.mydomain/";       # Root web URL
    virtualHost = "news.mydomain";                # Setup a virtualhost
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
    enable = true;                                          # Enable Nginx
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."news.mydomain" = {                        # TT-RSS hostname
      enableACME = true;                                    # Use ACME certs
      forceSSL = true;                                      # Force SSL
    };
  };

  security.acme.certs = {
      "news.mydomain".email = "email@mydomain";
  };

}
