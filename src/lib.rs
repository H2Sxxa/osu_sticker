use std::ffi::{c_char, c_float, c_int, CStr};

use image::{load_from_memory, Rgba};
use imageproc::drawing::draw_text;
use rusttype::Font;

#[no_mangle]
pub extern "C" fn generate_osu(
    text: *const c_char,
    x: c_int,
    y: c_int,
    size_x: c_float,
    size_y: c_float,
    savepath: *const c_char,
) {
    let font = Font::try_from_bytes(include_bytes!("../resource/Aller-Bold.ttf"))
        .unwrap_or_else(|| panic!("Font load error"));
    let bg =
        load_from_memory(include_bytes!("../resource/osu.png")).unwrap_or_else(|e| panic!("{}", e));
    let out = draw_text(
        &bg,
        Rgba([255u8, 255u8, 255u8, 255u8]),
        x,
        y,
        rusttype::Scale {
            x: size_x,
            y: size_y,
        },
        &font,
        unsafe {
            CStr::from_ptr(text)
                .to_str()
                .expect("error in accept a string 'text'")
        },
    );
    out.save_with_format(
        unsafe {
            CStr::from_ptr(savepath)
                .to_str()
                .expect("error in accept a string 'savepath'")
        },
        image::ImageFormat::Png,
    )
    .unwrap();
}
