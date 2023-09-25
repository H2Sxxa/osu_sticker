// ignore_for_file: non_constant_identifier_names

import 'dart:ffi';

import 'package:flutter/material.dart';

final LIB_OSU_STICKER = DynamicLibrary.open("libosu_sticker.so");

final generate_osu =
    LIB_OSU_STICKER.lookupFunction("generate_osu");

Image getDefault() {
  return Image.asset("images/default.png");
}
