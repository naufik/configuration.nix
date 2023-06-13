# NixOS Configuration

The full configuration assumes that the `root` user's `nix-channel` are set to point to:

- `nixos` points to `nixos-23.05`
- `home-manager` points to `home-manager/release-23.05`
- `unstable-pkgs` points to `nixpkgs-unstable`

In the process of moving the configuration to flakes. Ideally I want to get this done before 23.11.
## Classes

The goal is to separate different 'classes' of machines into their own configurations. So as this NixOS configuration is ported to different machines (unlikely, tbh), each machine is able to select its own "classes" and end up with an intersection of subset of configs that are available.

At the moment, `desktop` is the only class since that's the only thing I use NixOS for. It contains my `desktop` environment.

## Notes

**Experimental features - stage-1 systemd**

This configuration uses stage-1 systemd (`boot.initrd.systemd`) to run `plymouth-encrypt`. Which is currently [noted as experimental](https://search.nixos.org/options?channel=22.05&show=boot.initrd.systemd.enable&from=0&size=50&sort=relevance&type=packages&query=initrd.system) in NixOS 22.05 (have not checked for 23.05).

Some users are reporting that this option [does not work reliably](https://github.com/NixOS/nixpkgs/issues/26722#issuecomment-1147735675) so take caution. Disable with `boot.plymouth-encrypt.enable = false;`.

## Todo

- Flakes
- Self-isolate files.

## License

MIT License apply to the configuration files in this repository, but not the packages built.

Exceptions:
- Framework Laptop Logo in `./nix/sys/boot/logo.png`. All rights reserved by Framework Computer Inc.
