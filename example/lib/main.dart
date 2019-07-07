import 'package:flutter/material.dart';
import 'package:multiple_select/multiple_select.dart';

import 'package:multiple_select/multi_drop_down.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multiple Select Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Multiple Select Demo Page'),
        ),
        body: MultipleDropDown(
          placeholder: '请选择',
          elements: List.generate(15, (index) => MultipleSelectItem.build(value: index, display: '第$index项显示内容', content: '第$index项下拉内容')),
          onConfirm: (elements) {
            elements.forEach((element) => print(element.display));
          },
        ),
      ),
    );
  }
}
