# Building UEFI Rust apps in Nix

This repo contains a small example of how to build a UEFI application
written in Rust using Nix.

The main problem here is getting the `build-std` feature working with
[Naersk](https://github.com/nmattia/naersk). See `hello/Cargo.toml`
for the current workaround.

To build everything:

```sh
% nix-build -A hello
```
