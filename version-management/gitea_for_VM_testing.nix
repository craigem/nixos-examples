# Gitea configuration for the VMs running Gitea
#
# This file is intended to be imported into a file that defines the host, such
# as gitea_vm.nix in this directory. It is for playing with / testing Gitea and
# should not be used as an example of a production deployment.
#
# This is very basic Gitea setup, you can create an account, poke around even
# push git repos to it as per the README.

{ config, pkgs, lib, ... }:

{

  services.gitea = {
    enable = true;                              # Enable Gitea
    database = {
      type = "postgres";                        # Database type
      password = "gitea";                       # Set the password
    };
    domain = "gitea-vm";                        # Domain name
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
    virtualHosts."localhost" = {                            # Gitea hostname
      locations."/".proxyPass = "http://localhost:3001/";   # Proxy Gitea
    };
  };

}
