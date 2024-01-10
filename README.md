# NixOS Configuration

Configuration for my NixOS system(s). It's pretty shit I'll be honest, but... a good start.

## Structure

```
+ root
| flake.nix   - input
++ /nix/      -- like src
 +-- assets   -- dotfiles and other assets
 +-- desktop  -- configurations relating to my "desktop" system
 +-- home     -- users and home manager config
 +-- machines -- hardware-config.nix basically
 +-- sys      -- system modules i've written for practice
```

I need to clean up the structure to support multiple systems and grouping common modules together.

## Notes

**Experimental features - stage-1 systemd**

This configuration uses stage-1 systemd (`boot.initrd.systemd`) to run `plymouth-encrypt`. Which is currently [noted as experimental](https://search.nixos.org/options?channel=22.05&show=boot.initrd.systemd.enable&from=0&size=50&sort=relevance&type=packages&query=initrd.system) in NixOS 22.05 (have not checked for 23.11).

Some users are reporting that this option [does not work reliably](https://github.com/NixOS/nixpkgs/issues/26722#issuecomment-1147735675) so take caution. Disable with `boot.plymouth-encrypt.enable = false;`.

(I will need to re-test this.)

## Todo

- Some config still live outside of the realm of Nix. While I don't want to put everything in here I would love to include all settings that **make sense** to include when you boot up an OS for the first time. Such as `xmonad` configs.

## License

MIT License apply to the configuration files in this repository, but not the packages built.

Exceptions:
- Framework Laptop Logo in `./nix/sys/boot/logo.png`. All rights reserved by Framework Computer Inc.
