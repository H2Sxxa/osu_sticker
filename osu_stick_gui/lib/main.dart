import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'ffi_bridge.dart';

final Logger logger = Logger();

void main() {
  logger.i("bootstrap");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OSU!Sticker',
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink.shade700)),
      theme: ThemeData.light(
        useMaterial3: true,
      ).copyWith(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink.shade200)),
      home: const MyHomePage(title: 'OSU!Sticker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _size = 100;
  int _x = 75, _y = 125;
  String _text = "";
  Image _image = getDeafult();

  void generate() {
    logger.i("gen a picture");
    String cachepth = "cache.png";
    getApplicationCacheDirectory()
        .then((value) => cachepth = "${value.path}/cache.png");

    setState(() {
      generate_osu(toUtfPtr(_text), _x, _y, _size, _size, toUtfPtr(cachepth));
      _image = Image.memory(File(cachepth).readAsBytesSync());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(
            widget.title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          const SizedBox(
            height: 30,
          ),
          Center(
            child: Card(
                child: SizedBox(
              width: 350,
              height: 350,
              child: _image,
            )),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 160,
            height: 50,
            child: TextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text(
                    "输入生成文字",
                    textAlign: TextAlign.center,
                  )),
              onChanged: (value) {
                _text = value;
                generate();
              },
              onEditingComplete: () => generate(),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton.icon(
                onPressed: () async {},
                icon: const Icon(Icons.copy),
                label: const Text("copy"),
              ),
              const SizedBox(
                width: 20,
              ),
              FilledButton.icon(
                  onPressed: () async {
                    String? path = await FilePicker.platform
                        .saveFile(fileName: "result.png", type: FileType.image);
                    if (path == null) {
                      return;
                    }
                    await File("cache.png").copy(path);
                  },
                  icon: const Icon(Icons.save),
                  label: const Text("save")),
              const SizedBox(
                width: 20,
              ),
              FilledButton.icon(
                  onPressed: () {
                    setState(() {
                      _size = 100;
                      _x = 75;
                      _y = 125;
                      _text = "";
                    });
                  },
                  icon: const Icon(Icons.restore),
                  label: const Text("reset"))
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text(
              "字体大小",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Slider(
              value: _size,
              onChanged: (v) {
                setState(() {
                  _size = v;
                  generate();
                });
              },
              min: 0,
              max: 300,
              label: "$_size",
            ),
            IconButton.filled(
                onPressed: () => setState(() {
                      _size = 100;
                      generate();
                    }),
                icon: const Icon(Icons.restore))
          ]),
          const SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text(
              "横向位置",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Slider(
              value: _x.toDouble(),
              onChanged: (v) {
                setState(() {
                  _x = v.toInt();
                  generate();
                });
              },
              min: 0,
              max: 350,
              label: "sizex",
            ),
            IconButton.filled(
                onPressed: () => setState(() {
                      _x = 75;
                      generate();
                    }),
                icon: const Icon(Icons.restore))
          ]),
          const SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text(
              "纵向位置",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Slider(
              value: _y.toDouble(),
              onChanged: (v) {
                setState(() {
                  _y = v.toInt();
                  generate();
                });
              },
              min: 0,
              max: 350,
              label: "sizey",
            ),
            IconButton.filled(
                onPressed: () => setState(() {
                      _y = 125;
                      generate();
                    }),
                icon: const Icon(Icons.restore))
          ])
        ])));
  }
}
