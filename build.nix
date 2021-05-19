{ lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "hello";
  src = ./hello;

  cargoSha256 = "0ik7mfamzck1wfbiickaris9da44c4wlxix135jw2c1m2ij5zzsr";
}
