import 'package:flutter/material.dart';

class NumberCategoryDropDown extends StatefulWidget {

  @override
  State<NumberCategoryDropDown> createState() => _NumberCategoryDropDownState();
}

class _NumberCategoryDropDownState extends State<NumberCategoryDropDown> {

  List<String> numberCategory = ['Mobile', 'Home', 'Work', 'Other'];
  String _selectedNumCategory = '';

  @override
  void initState() {
    super.initState();
    _selectedNumCategory = numberCategory[0];
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
              value: _selectedNumCategory,
              //Map the values for dropdown from the item list
              items: numberCategory.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _selectedNumCategory = value ?? '';
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