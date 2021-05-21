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

  nightlyRustPlatform = (import sources.nixpkgs {
    crossSystem = {
      config = "x86_64-linux";
      rustc.config = "x86_64-unknown-uefi";
    };

    # This unfortunately also doesn't resolve the linking problems.
    #
    # crossSystem = pkgs.lib.systems.examples.mingwW64 // {
    #   rustc.config = "x86_64-unknown-uefi";
    # };
  }).makeRustPlatform {
    rustc = nightlyRust;
    cargo = nightlyRust;
  };

in {
  # For playing around in nix repl.
  inherit rustOverlay pkgs;

  ## Naersk
  #
  # This is a Rust no_std binary that wants to be built as UEFI
  # app. See it's Cargo.toml for how I've pulled in the dependencies
  # for the Rust toolchain.
  hello = naersk.buildPackage {
    src = ./hello;
  };

  ## nixpkgs buildRustPackage
  #
  # This is the same as `hello` above just with the nixpkgs tooling.
  hello-nixpkgs = nightlyRustPlatform.buildRustPackage {
    name = "uefi-hello";

    src = ./hello;

    # According to the manual this should work, but it doesn't. We do
    # need the `crossSystem` above to set the target.
    #
    # target = "x86_64-unknown-uefi";

    # Use the following, if you need to update the hash:
    #  cargoHash = pkgs.lib.fakeHash;
    cargoHash = "sha256:1vkk99l5yw0n45pqd507ra7q6yhdqr1amc01pjaj9qrzzlvppv8f";
  };
}
