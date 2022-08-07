import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class MainReactiveDropDown extends StatelessWidget {
  final dynamic model;
  final String controllerName;
  final String label;
  final List<DropdownMenuItem> itemList;
  final Function onChanged;
  MainReactiveDropDown({
    @required this.controllerName,
    @required this.model,
    @required this.itemList,
    this.label,
    this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ReactiveDropdownField<dynamic>(
        
        icon: Icon(
          // Icons.keyboard_arrow_down,
          Icons.arrow_drop_down,
          size: 35,
          color: Colors.black,
        ),
        formControlName: controllerName,
        decoration: InputDecoration(
          hintText: label ?? controllerName,
          hintStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        onChanged: onChanged,
        items: itemList,
      ),
    );
  }
}