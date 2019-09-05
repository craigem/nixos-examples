# NixOps configuration for the VMs running Gitea

{ config, pkgs, lib, ... }:

{

  services.gitea = {
    enable = true;                              # Enable Gitea
    database = {
      type = "postgres";                        # Database type
      password = "gitea";                       # Set the password
    };
    domain = "source.mcwhirter.io";             # Domain name
    rootUrl = "http://localhost/";              # Root web URL
    httpPort = 3001;                            # Provided unique port
  };

  services.postgresql = {
    enable = true;                # Ensure postgresql is enabled
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
    virtualHosts."localhost" = {                  # Gitea hostname
      locations."/".proxyPass = "http://localhost:3001/";   # Proxy Gitea
    };
  };

}
