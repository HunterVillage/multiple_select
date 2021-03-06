import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multiple_select/Item.dart';
import 'package:multiple_select/multi_filter_select_page.dart';

typedef SelectCallback = Function(List? selectedValue);

/// 模糊查询多选
class MultiFilterSelect extends StatefulWidget {
  final double? height;
  final String? hintText;
  final TextStyle? hintStyle;
  final double? fontSize;
  final Widget? tail;
  final List<Item> allItems;
  final List? initValue;
  final SelectCallback selectCallback;
  final bool disabled;
  final bool autoOpenKeyboard;
  final bool searchCaseSensitive;
  final Color selectedTextColor;
  final Color selectedBackgroundColor;
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;

  MultiFilterSelect(
      {this.height,
      this.hintText,
      this.hintStyle,
      this.fontSize,
      this.tail,
      required this.allItems,
      this.initValue,
      required this.selectCallback,
      this.disabled = false,
      this.autoOpenKeyboard = true,
      this.searchCaseSensitive = false,
      this.selectedTextColor = Colors.white,
      this.selectedBackgroundColor = Colors.blue,
      this.textColor = Colors.black54,
      this.backgroundColor = Colors.grey,
      this.borderColor = Colors.black12});

  @override
  State<StatefulWidget> createState() => MultiFilterSelectState();
}

class MultiFilterSelectState extends State<MultiFilterSelect> {
  List? _selectedValue = [];

  @override
  Widget build(BuildContext context) {
    if (this.widget.initValue == null) {
      this._selectedValue = [];
    } else {
      this._selectedValue = this.widget.initValue;
    }
    return Opacity(
      opacity: this.widget.disabled ? 0.4 : 1,
      child: GestureDetector(
        onTap: () async {
          if (!this.widget.disabled) {
            this._selectedValue = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MultiFilterSelectPage(
                    allItems: this.widget.allItems,
                    searchCaseSensitive: this.widget.searchCaseSensitive,
                    initValue: this.widget.initValue ?? [],
                    autoFocusKeyboard: this.widget.autoOpenKeyboard,
                    selectedTextColor: widget.selectedTextColor,
                    selectedBackgroundColor: widget.selectedBackgroundColor,
                    textColor: widget.textColor,
                    backgroundColor: widget.backgroundColor,
                    borderColor: widget.borderColor),
              ),
            );
            this.setState(() {});
            this.widget.selectCallback(_selectedValue);
          }
        },
        child: this._selectedValue!.length > 0 ? this._getValueWrp() : this._getEmptyWrp(),
      ),
    );
  }

  Widget _getEmptyWrp() {
    return Container(
      height: this.widget.height ?? 40,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              child: Text(
                this.widget.hintText ?? '',
                style: this.widget.hintStyle ??
                    TextStyle(
                        fontSize: this.widget.fontSize ?? 16,
                        color: widget.textColor,
                        decoration: TextDecoration.none),
              ),
              padding: EdgeInsets.only(top: 8, bottom: 8, left: 10),
            ),
          ),
          this.widget.tail ??
              Container(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5.5),
                child: Icon(Icons.list, color: widget.textColor, size: 25),
              ),
        ],
      ),
      decoration:
          BoxDecoration(border: Border(bottom: BorderSide(width: 0.5, color: widget.borderColor))),
    );
  }

  Widget _getValueWrp() {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: this
            .widget
            .allItems
            .where((item) => this._selectedValue!.contains(item.value))
            .map((item) => GestureDetector(
                  onLongPress: () {
                    if (!this.widget.disabled) {
                      this._selectedValue!.remove(item.value);
                      this.setState(() {});
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    child: Text(
                      item.display,
                      style: TextStyle(fontSize: 15, color: widget.selectedTextColor),
                    ),
                    decoration: BoxDecoration(
                      color: widget.selectedBackgroundColor,
                      border:
                          Border.all(width: 1, style: BorderStyle.solid, color: widget.borderColor),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ))
            .toList(),
      ),
      decoration:
          BoxDecoration(border: Border(bottom: BorderSide(width: 0.5, color: widget.borderColor))),
    );
  }
}
