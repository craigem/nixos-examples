Example of Running Hydra from Upstream Source
=============================================

To use the VM the files create, I recommend first setting some Qemu options in your
shell.

The first increases the VM's RAM to 4G:

```
$ export QEMU_OPTS="-m 4192"
```

The second, configures some port forwarding:

```
$ export QEMU_NET_OPTS="hostfwd=tcp::10443-:443,hostfwd=tcp::10022-:22"
```

which enables you to ssh to the vm  with `ssh nixos@localhost -p 10022` and to
hit the Hydra web interface on `localhosts:10443`.

Make sure that you have checked out the `Hydra source`_ somewhere locally and
set the `imports` path correctly in `hydra_notify.nix`:

```
  imports =
    [
      "/path/to/source/hydra/hydra-module.nix"
    ];
```

To build the VM:

```
$ nix-build '<nixpkgs/nixos>' -A vm --arg configuration ./hydra_vm.nix
```

To launch the VM:

```
$ ./result/bin/run-hydra-notications-vm
```

You should now find yourself running a VM with Hydra and the `hydra-notify`
service running.

.. _Hydra source: https://github.com/NixOS/hydra/
