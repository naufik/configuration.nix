# NixOS Configuration

The full configuration assumes that the `root` user's `nix-channel` are set to point to:

- `nixos` points to `nixos-22.11`
- `home-manager` points to `home-manager/release-22.11`
- `unstable-pkgs` points to `nixpkgs-unstable`

## Classes

This entire thing is WIP.

The goal is to separate different 'classes' of machines into their own cohesive configuration. So as this NixOS configuration is ported to different machines (unlikely, tbh), each machine is able to select its own "classes" and end up with an intersection of subset of configs that are available.

At the moment, `desktop` is the only class since that's the only thing I use NixOS for. It contains my `desktop` environment. May add a `server` class for specific things.

## Notes and Versioning

**Lack of self-isolation of config files**

This setup is not yet self-isolated, meaning that the *desired* system experience may not be fully replicated using `configuration.nix` alone and still require some imperative setup. Example of non-nixxed components:

- Window manager dotfiles.
- System programs dotfiles (e.g. `alacritty.yml`).
- Editor extensions (nvim and vscodium). *may not be nixxed*

**Experimental features - stage-1 systemd**

This configuration uses stage-1 systemd (`boot.initrd.systemd`) to run `plymouth-encrypt`. Which is currently [noted as experimental](https://search.nixos.org/options?channel=22.05&show=boot.initrd.systemd.enable&from=0&size=50&sort=relevance&type=packages&query=initrd.system) in NixOS 22.05.

Some users are reporting that this option [does not work reliably](https://github.com/NixOS/nixpkgs/issues/26722#issuecomment-1147735675) so take caution. Disable with `boot.plymouth-encrypt.enable = false;`.

## License

MIT License apply to the configuration files in this repository, but not the packages built.

Exceptions:
- Framework Laptop Logo in `./nix/sys/boot/logo.png`. All rights reserved by Framework Computer Inc.
