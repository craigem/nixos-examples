# NixOps configuration for the VMs running Hydra

{ config, pkgs, lib, ... }:

{

  services.postfix = {
    enable = true;
    setSendmail = true;
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql;
    identMap =
      ''
        hydra-users hydra hydra
        hydra-users hydra-queue-runner hydra
        hydra-users hydra-www hydra
        hydra-users root postgres
        hydra-users postgres postgres
      '';
  };

  networking.firewall.allowedTCPPorts = [ config.services.hydra.port ];

  services.hydra = {
    enable = true;
    useSubstitutes = true;
    hydraURL = "https://hydra.mcwhirter.io";
    notificationSender = "hydra.mcwhirter.io";
    buildMachinesFiles = [];
    extraConfig = ''
      store_uri = file:///var/lib/hydra/cache?secret-key=/etc/nix/hydra.mcwhirter.io/secret
      binary_cache_secret_key_file = /etc/nix/hydra.mcwhirter.io/secret
      binary_cache_dir = /var/lib/hydra/cache
    '';
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts."hydra.mcwhirter.io" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass = "http://localhost:3000";
    };
  };

  security.acme.certs = {
      "hydra.mcwhirter.io".email = "craige@mcwhirter.io";
  };

  systemd.services.hydra-manual-setup = {
    description = "Create Admin User for Hydra";
    serviceConfig.Type = "oneshot";
    serviceConfig.RemainAfterExit = true;
    wantedBy = [ "multi-user.target" ];
    requires = [ "hydra-init.service" ];
    after = [ "hydra-init.service" ];
    environment = builtins.removeAttrs (config.systemd.services.hydra-init.environment) ["PATH"];
    script = ''
      if [ ! -e ~hydra/.setup-is-complete ]; then
        # create signing keys
        /run/current-system/sw/bin/install -d -m 551 /etc/nix/hydra.mcwhirter.io
        /run/current-system/sw/bin/nix-store --generate-binary-cache-key hydra.mcwhirter.io /etc/nix/hydra.mcwhirter.io/secret /etc/nix/hydra.mcwhirter.io/public
        /run/current-system/sw/bin/chown -R hydra:hydra /etc/nix/hydra.mcwhirter.io
        /run/current-system/sw/bin/chmod 440 /etc/nix/hydra.mcwhirter.io/secret
        /run/current-system/sw/bin/chmod 444 /etc/nix/hydra.mcwhirter.io/public
        # create cache
        /run/current-system/sw/bin/install -d -m 755 /var/lib/hydra/cache
        /run/current-system/sw/bin/chown -R hydra-queue-runner:hydra /var/lib/hydra/cache
        # done
        touch ~hydra/.setup-is-complete
      fi
    '';
  };
  nix.trustedUsers = ["hydra" "hydra-evaluator" "hydra-queue-runner"];
  nix.buildMachines = [
    {
      hostName = "localhost";
      systems = [ "x86_64-linux" "i686-linux" ];
      maxJobs = 6;
      # for building VirtualBox VMs as build artifacts, you might need other
      # features depending on what you are doing
      supportedFeatures = [ ];
    }
  ];
}
