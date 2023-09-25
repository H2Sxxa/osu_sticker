// ignore_for_file: non_constant_identifier_names

//import 'dart:ffi';

import 'package:flutter/material.dart';

//final LIB_OSU_STICKER = DynamicLibrary.open("libosu_sticker.so");

//typedef Generater_OSU = Void Function(String, int, int, double, double, String);
//typedef Generater_OSU_C = Void Function(
//    Pointer<Int8>, Int32, Int32, Float, Float, Pointer<Int8>);

//final generate_osu = LIB_OSU_STICKER
//   .lookupFunction<Generater_OSU_C, Generater_OSU>("generate_osu");

Image getDefault() {
  return Image.asset("images/default.png");
}
