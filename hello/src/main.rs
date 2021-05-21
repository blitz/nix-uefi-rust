#![no_main]
#![no_std]
#![feature(abi_efiapi)]

use log::info;
use uefi::prelude::*;

#[entry]
fn efi_main(_image_handler: uefi::Handle, system_table: SystemTable<Boot>) -> Status {
    uefi_services::init(&system_table).expect_success("Failed initialize UEFI services");

    info!("Hello!");

    Status::SUCCESS
}
