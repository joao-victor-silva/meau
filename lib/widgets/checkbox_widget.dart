import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meau/model/checkbox_model.dart';

class CheckboxWidget extends StatefulWidget {
  final CheckBoxModel item;

  const CheckboxWidget({super.key, required this.item});

  @override
  _CheckboxWidgetState createState() => _CheckboxWidgetState();
}

class _CheckboxWidgetState extends State<CheckboxWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: widget.item.checked,
          onChanged: (value) {
            setState(() {
              widget.item.checked = value ?? false;
            });
          },
        ),
        Text(
          widget.item.text,
          style: TextStyle(
            fontFamily: "Roboto Regular",
            fontSize: 14.0,
            color: Color(0xff757575),
          ),
        ),
      ],
    );
  }
}
