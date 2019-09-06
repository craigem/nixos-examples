# This is an example secret file for NixOps managed hosts.
#
# You would not normally have this in a public repo and should make sure it's
# in your .gitignore file to prevent accidentally leaking your passwords.

{ config, pkgs, ... }:

{
  deployment.keys = {
    # An example set of keys to be used for the Gitea service's DB authentication
    gitea-dbpass = {
      text        = "uNgiakei+x>i7shuiwaeth3z";   # Password, generated using pwgen -yB 24
      user        = "gitea";                      # User to own the key file
      group       = "wheel";                      # Group to own the key file
      permissions = "0640";                       # Key file permissions
    };
  };
}
