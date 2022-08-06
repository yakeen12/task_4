import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:task_4/qr.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _image;
  DateTime date = DateTime(2022, 12, 20);
  Color? c;

  Future getImage(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image == null) return;
      final tempImage = File(image.path);
      setState(() {
        this._image = tempImage;
      });
    } on PlatformException catch (e) {
      print("Failed to pick image $e");
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? nowDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1990),
        lastDate: DateTime.now());
    if (nowDate != null && nowDate != date) {}
    setState(() {
      date = nowDate!;
    });
  }

  void _selectColor(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Choose Text Color"),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                ColorPicker(
                    pickerColor: Colors.black,
                    onColorChanged: (color) => setState(() {
                          c = color;
                        })),
                TextButton(
                  child: Text("Select"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                ),
              ]),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Text editor"),
      ),
      body: ListView(children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: Container(
              child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => QR()));
                    },
                    child: Text("QR Scanner"),
                  ),
                  Container(
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await _selectDate(context);
                          },
                          child: Text("Date"),
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        Text("${date.year}/ ${date.month}/ ${date.day}"),
                      ],
                    ),
                  )
                ],
              ),
              Container(
                child: Column(
                  children: [
                    TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: c,
                      ),
                    ),
                    if (_image != null)
                      Image.file(
                        _image!,
                        height: 250,
                        width: 250,
                      ),
                    TextField(
                      style: TextStyle(color: c),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                      onPressed: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        await Future.delayed(Duration(milliseconds: 50));
                        _selectColor(context);
                      },
                      icon: Icon(Icons.colorize_sharp)),
                  IconButton(
                      onPressed: () {
                        getImage(ImageSource.camera);
                      },
                      icon: Icon(Icons.camera_alt_outlined)),
                  IconButton(
                      onPressed: () {
                        getImage(ImageSource.gallery);
                      },
                      icon: Icon(Icons.photo_size_select_actual_rounded)),
                ],
              )
            ],
          )),
        ),
      ]),
    );
  }
}
