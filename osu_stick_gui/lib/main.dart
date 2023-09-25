import 'package:flutter/material.dart';
import 'ffi_bridge.dart';

void main() {
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
  double _sizex = 0, _sizey = 0;
  int _x = 0, _y = 0;

  void generate() {
    generate_osu(_x, _y, _sizex, _sizey);
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
              child: getDefault(),
            )),
          ),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            width: 160,
            height: 50,
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text(
                    "输入生成文字",
                    textAlign: TextAlign.center,
                  )),
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
                onPressed: () {},
                icon: const Icon(Icons.copy),
                label: const Text("copy"),
              ),
              const SizedBox(
                width: 20,
              ),
              FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.save),
                  label: const Text("save"))
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text("字体大小X"),
            Slider(
              value: _sizex,
              onChanged: (v) {
                setState(() {
                  _sizex = v;
                });
              },
              label: "sizex",
            ),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text("字体大小Y"),
            Slider(
              value: _sizey,
              onChanged: (v) {
                setState(() {
                  _sizey = v;
                });
              },
              label: "sizeY",
            ),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text("字体位置X"),
            Slider(
              value: _x.toDouble(),
              onChanged: (v) {
                setState(() {
                  _x = v.toInt();
                });
              },
              min: 0,
              max: 350,
              label: "sizex",
            ),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text("字体位置Y"),
            Slider(
              value: _y.toDouble(),
              onChanged: (v) {
                setState(() {
                  _y = v.toInt();
                });
              },
              min: 0,
              max: 350,
              label: "sizex",
            ),
          ])
        ])));
  }
}
