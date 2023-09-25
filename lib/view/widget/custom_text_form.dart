import 'package:flutter/material.dart';


Widget customTextForm({
  required String label ,
  required bool isPassword ,
  required IconData preIcon ,
  required TextEditingController controller ,

})
{
  return TextFormField(
    decoration: InputDecoration(
      border:const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(28))),
      prefixIcon: Icon(preIcon),
      label: Text(label),
    ),
    obscureText: isPassword,
    controller: controller,
  );

}