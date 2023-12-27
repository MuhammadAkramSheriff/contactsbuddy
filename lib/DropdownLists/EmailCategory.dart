import 'package:flutter/material.dart';

class EmailCategoryDropDown extends StatefulWidget {

  @override
  State<EmailCategoryDropDown> createState() => _EmailCategoryDropDownState();
}

class _EmailCategoryDropDownState extends State<EmailCategoryDropDown> {

  List<String> emailCategory = ['Personal','Work','Other'];
  String _selectedEmailCategory = '';

  @override
  void initState() {
    super.initState();
    _selectedEmailCategory = emailCategory[0];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 65,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        children: [
          SizedBox(height: 10),
          Center(
            child: DropdownButton<String>(
              value: _selectedEmailCategory,
              //Map the values for dropdown from the item list
              items: emailCategory.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _selectedEmailCategory = value ?? '';
                });
              },
              underline: Container(),
            ),
          ),
        ],
      ),
    );
  }
}