tt-rss_vm.nix
-------------

A Nix configuration for a VM to run Tiny Tiny RSS (TT-RSS).

It is intended as an example of building a VM that builds TT-RSS for testing
and evaluation purposes. I does not represent a production or secure
deployment.

To use this file:

**Build with:**

.. code:: bash

  $ nix-build '<nixpkgs/nixos>' -A vm --arg configuration ./tt-rss_vm.nix


**Export** these variables, adjusting to suit yourself:

.. code:: bash

  $ export QEMU_OPTS="-m 4192"
  $ export QEMU_NET_OPTS="hostfwd=tcp::18080-:80,hostfwd=tcp::10022-:22"

**Launch** the VM with:

.. code:: bash

  $ ./result/bin/run-tt-rss-vm

You should now be able to:

* Login via the shell
* Login via ssh: :code:`ssh nixos@localhost -p 10022`
* Login via the web: `http://localhost:18080/`_

The default user for TT-RSS is  "admin" and the default password is "password".

.. _http://localhost:18080/: http://localhost:18080/

tt-rss_for_VM_testing.nix
-------------------------

This file describes the TT-RSS configuration to be deployed. As such it
represents a deployment only suitable to testing purposes and should not be
used as an example of a production deployment.


tt-rss_for_NixOps.nix
---------------------

This provides an example of a production deployment of TT-RSS via NixOps.
