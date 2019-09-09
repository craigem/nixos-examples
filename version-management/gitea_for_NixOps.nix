# Example NixOps configuration for the hosts running Gitea
#
# Will need to be used with an appropriate sercets file. See: ../secrets.nix

{ config, pkgs, lib, ... }:

{

  services.gitea = {
    enable = true;                               # Enable Gitea
    appName = "MyDomain: Gitea Service";         # Give the site a name
    database = {
      type = "postgres";                         # Database type
      passwordFile = "/run/keys/gitea-dbpass";   # Where to find the password
    };
    domain = "source.mydomain.tld";              # Domain name
    rootUrl = "https://source.mydomaain.tld/";   # Root web URL
    httpPort = 3001;                             # Provided unique port
    extraConfig = let
      docutils =
        pkgs.python37.withPackages (ps: with ps; [
          docutils                               # Provides rendering of ReStructured Text files
          pygments                               # Provides syntax highlighting
      ]);
    in ''
      [mailer]
      ENABLED = true
      FROM = "gitea@mydomain.tld"
      [service]
      REGISTER_EMAIL_CONFIRM = true
      [markup.restructuredtext]
      ENABLED = true
      FILE_EXTENSIONS = .rst
      RENDER_COMMAND = ${docutils}/bin/rst2html.py
      IS_INPUT_FILE = false
    '';
  };

  services.postgresql = {
    enable = true;                # Ensure postgresql is enabled
    authentication = ''
      local gitea all ident map=gitea-users
    '';
    identMap =                    # Map the gitea user to postgresql
      ''
        gitea-users gitea gitea
      '';
  };

  services.nginx = {
    enable = true;                                          # Enable Nginx
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."source.MyDomain.tld" = {                  # Gitea hostname
      enableACME = true;                                    # Use ACME certs
      forceSSL = true;                                      # Force SSL
      locations."/".proxyPass = "http://localhost:3001/";   # Proxy Gitea
    };
  };

  security.acme.certs = {
      "source.mydomain".email = "anEmail@mydomain.tld";
  };

}
