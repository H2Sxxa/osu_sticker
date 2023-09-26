// ignore_for_file: non_constant_identifier_names

//import 'dart:ffi';

import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';

//final LIB_OSU_STICKER = DynamicLibrary.open("libosu_sticker.so");
final DynamicLibrary nativeLib = Platform.isAndroid
    ? DynamicLibrary.open('lib/libosu_sticker.so')
    : Platform.isWindows
        ? DynamicLibrary.open('lib/libosu_sticker.dll')
        : DynamicLibrary.process();

final void Function(Pointer<Utf8> text, int x, int y, double size_x,
        double size_y, Pointer<Utf8> savepath) generate_osu =
    nativeLib
        .lookup<
            NativeFunction<
                Void Function(
                    Pointer<Utf8> text,
                    Int32 x,
                    Int32 y,
                    Float size_x,
                    Float size_y,
                    Pointer<Utf8> savepath)>>("generate_osu")
        .asFunction();

Image getDeafult() {
  return Image.asset("images/default.png");
}

Pointer<Utf8> toUtfPtr(String x) {
  return x.toNativeUtf8();
}
