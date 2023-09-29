// ignore_for_file: non_constant_identifier_names

//import 'dart:ffi';

import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:osu_stick_gui/main.dart';
import 'package:path_provider/path_provider.dart';

//final LIB_OSU_STICKER = DynamicLibrary.open("libosu_sticker.so");
final DynamicLibrary nativeLib = handle_dylib();

DynamicLibrary handle_dylib() {
  if (Platform.isAndroid) {
    return DynamicLibrary.open("libosu_sticker.so");
    String sopth = "";
    getApplicationSupportDirectory()
        .then((value) => sopth = "${value.path}/libosu_sticker.so");
    rootBundle.load("lib/libosu_sticker.so").then((value) async {
      Directory? external_dir = await getExternalStorageDirectory();
      Directory inner_dir = await getApplicationSupportDirectory();
      external_dir ??= inner_dir;
      String dbg_so = "${external_dir.path}/dbg_libosu_sticker.so";
      if (await File(dbg_so).exists()) {
        logger.w("load dbg .so!");
        await File(dbg_so).copy(sopth);
      } else {
        await File(sopth).writeAsBytes(value.buffer.asUint8List());
      }
    });
    return DynamicLibrary.open(sopth);
  } else if (Platform.isWindows) {
    return DynamicLibrary.open('libosu_sticker.dll');
  } else {
    return DynamicLibrary.process();
  }
}

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

Uint8List getPNGBuforDf() {
  String cachepth = "cache.png";
  if (Platform.isAndroid) {
    getApplicationCacheDirectory()
        .then((value) => cachepth = "${value.path}/cache.png");
  }
  return File(cachepth).readAsBytesSync();
}

Pointer<Utf8> toUtfPtr(String x) {
  return x.toNativeUtf8();
}
