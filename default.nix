let
  sources = import ./nix/sources.nix;

  # Get Rust Nightly via https://github.com/oxalica/rust-overlay.
  rustOverlay = import sources.rust-overlay;

  pkgs = import sources.nixpkgs {
    overlays = [ rustOverlay ];
  };

  # To rebuild the standard library, we need source code to be
  # available.
  nightlyRust = pkgs.rust-bin.nightly.latest.default.override {
    extensions = [ "rust-src" ];
  };

  # Make naersk use our prepared Rust toolchain.
  naersk = pkgs.callPackage (import sources.naersk) {
    rustc = nightlyRust;
    cargo = nightlyRust;
  };

in {
  # For playing around in nix repl.
  inherit rustOverlay pkgs;

  # This is a Rust no_std binary that wants to be built as UEFI
  # app. See it's Cargo.toml for how I've pulled in the dependencies
  # for the Rust toolchain.
  hello = naersk.buildPackage {
    src = ./hello;
  };
}
