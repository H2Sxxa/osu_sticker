use std::ffi::{c_char, c_float, c_int, CStr};

use image::{load_from_memory, DynamicImage, Rgba};
use imageproc::drawing::draw_text;
use rusttype::Font;

const FONT_B: &[u8] = include_bytes!("../resource/Aller-Bold.ttf");
const BG_B: &[u8] = include_bytes!("../resource/osu.png");

pub fn get_font() -> Font<'static> {
    Font::try_from_bytes(FONT_B).unwrap_or_else(|| panic!("error in load font"))
}

pub fn get_bg() -> DynamicImage {
    load_from_memory(BG_B).unwrap_or_else(|e| panic!("{}", e))
}

pub fn generate_osu_r(text: String, x: i32, y: i32, size_x: f32, size_y: f32, savepath: String) {
    let out = draw_text(
        &get_bg(),
        Rgba([255u8, 255u8, 255u8, 255u8]),
        x,
        y,
        rusttype::Scale {
            x: size_x,
            y: size_y,
        },
        &get_font(),
        &text,
    );
    out.save_with_format(savepath.as_str(), image::ImageFormat::Png)
        .unwrap();
}

#[no_mangle]
pub extern "C" fn generate_osu(
    text: *const c_char,
    x: c_int,
    y: c_int,
    size_x: c_float,
    size_y: c_float,
    savepath: *const c_char,
) {
    generate_osu_r(
        unsafe { CStr::from_ptr(text).to_string_lossy().to_string() },
        x,
        y,
        size_x,
        size_y,
        unsafe { CStr::from_ptr(savepath).to_string_lossy().to_string() },
    )
}

