import 'package:flutter/material.dart';


class getTextFormField extends StatelessWidget {
  TextEditingController controller;
  String hintName;
  bool isObscureText;
  TextInputType inputType;
  bool isEnable;
  final bool enableValidation;

  getTextFormField(
      {required this.controller,
        required this.hintName,
        this.isObscureText = false,
        this.inputType = TextInputType.text,
        this.isEnable = true,
        this.enableValidation = false,
      });


  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        controller: controller,
        obscureText: isObscureText,
        enabled: isEnable,
        keyboardType: inputType,
        validator: enableValidation ? (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $hintName';
          }
          return null;
          }
          : null,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            borderSide: BorderSide(color: Colors.green),
          ),
          hintText: hintName,
          fillColor: Colors.grey[200],
          filled: true,
        ),
      ),
    );
  }
}