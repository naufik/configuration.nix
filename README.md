# NixOS Configuration

Nix Flakes based configuration for my NixOS system(s). This has been recently converted into flakes, please don't look way too closely to my code.

This is intended to host multiple configurations. However as of today I am only hosting one configuration: **desktop**.

## Notes

**Experimental features - stage-1 systemd**

This configuration uses stage-1 systemd (`boot.initrd.systemd`) to run `plymouth-encrypt`. Which is currently [noted as experimental](https://search.nixos.org/options?channel=22.05&show=boot.initrd.systemd.enable&from=0&size=50&sort=relevance&type=packages&query=initrd.system) in NixOS 22.05 (have not checked for 23.05).

Some users are reporting that this option [does not work reliably](https://github.com/NixOS/nixpkgs/issues/26722#issuecomment-1147735675) so take caution. Disable with `boot.plymouth-encrypt.enable = false;`.

(I will need to re-test this.)

## Todo

- Some config still live outside of the realm of Nix. While I don't want to put everything in here I would love to include all settings that **make sense** to include when you boot up an OS for the first time. Such as `xmonad` configs.

## License

MIT License apply to the configuration files in this repository, but not the packages built.

Exceptions:
- Framework Laptop Logo in `./nix/sys/boot/logo.png`. All rights reserved by Framework Computer Inc.
