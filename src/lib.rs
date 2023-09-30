use std::{
    ffi::{c_char, c_float, c_int, c_uchar, CStr},
    io::Cursor,
};

use image::{load_from_memory, DynamicImage, EncodableLayout, ImageBuffer, ImageFormat, Rgba};
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

fn draw_osu_text(
    text: String,
    x: i32,
    y: i32,
    size_x: f32,
    size_y: f32,
) -> ImageBuffer<Rgba<u8>, Vec<u8>> {
    draw_text(
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
    )
}

pub fn generate_osu_r(text: String, x: i32, y: i32, size_x: f32, size_y: f32, savepath: String) {
    draw_osu_text(text, x, y, size_x, size_y)
        .save_with_format(savepath.as_str(), image::ImageFormat::Png)
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

#[no_mangle]
pub extern "C" fn generate_osu_b(
    text: *const c_char,
    x: c_int,
    y: c_int,
    size_x: c_float,
    size_y: c_float,
    byte_len: *mut c_int,
) -> *const c_uchar {
    let mut writer = Cursor::new(Vec::new());
    draw_osu_text(
        unsafe { CStr::from_ptr(text).to_string_lossy().to_string() },
        x,
        y,
        size_x,
        size_y,
    )
    .write_to(&mut writer, ImageFormat::Png)
    .unwrap_or_else(|e| panic!("{}", e));
    unsafe {
        *byte_len = writer.clone().into_inner().as_bytes().len() as i32;
    }
    writer.into_inner().as_bytes().as_ptr()
}

#[no_mangle]
pub extern "C" fn test_useable() -> c_int {
    1
}
