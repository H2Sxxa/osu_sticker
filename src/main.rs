use std::io::stdin;

use image::{load_from_memory, Rgba};
use imageproc::drawing::draw_text;
use rusttype::Font;

fn main() {
    let font = Font::try_from_bytes(include_bytes!("../resource/Aller-Bold.ttf"))
        .unwrap_or_else(|| panic!("Font load error"));
    let bg =
        load_from_memory(include_bytes!("../resource/osu.png")).unwrap_or_else(|e| panic!("{}", e));
    println!("💡 Input ascii char and it will generate a picturn in local directory!");
    loop {
        let mut text = String::new();
        stdin().read_line(&mut text).expect("input error");
        text.pop();
        let out = draw_text(
            &bg,
            Rgba([255u8, 255u8, 255u8, 255u8]),
            90,
            125,
            rusttype::Scale {
                x: 100f32,
                y: 100f32,
            },
            &font,
            text.as_str(),
        );
        out.save_with_format("result.png", image::ImageFormat::Png)
            .unwrap();
        println!("🆗 Save as \"./result.png\"")
    }
}
