import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormInputWidget extends StatelessWidget {
  final String? placeholder;
  final List<TextInputFormatter>? inputFormatters;

  final Function(String) change;

  const FormInputWidget(
      {Key? key, required this.change, this.placeholder, this.inputFormatters})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: placeholder,
          border: const OutlineInputBorder(),
        ),
        onChanged: change,
      ),
    );
  }
}
