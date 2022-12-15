import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormInputWidget extends StatelessWidget {
  final String? placeholder;
  final List<TextInputFormatter>? inputFormatters;

  const FormInputWidget({Key? key, this.placeholder, this.inputFormatters})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: placeholder,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
