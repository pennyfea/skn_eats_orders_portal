import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final int maxLine;
  final String title;
  final bool hasTitle;
  final String initialValue;
  final String? hintext;
  final Function(String)? onChanged;
  final Function()? onTap;
  final bool onlyDigits;
  final bool allowDecimal;
  final bool readOnly;

  const CustomTextFormField({
    super.key,
    required this.maxLine,
    required this.title,
    required this.hasTitle,
    this.hintext,
    required this.initialValue,
    this.onChanged,
    this.onTap,
    this.onlyDigits = false,
    this.allowDecimal = false,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        readOnly: readOnly,
        maxLines: maxLine,
        initialValue: initialValue,
        keyboardType: onlyDigits
            ? TextInputType.numberWithOptions(decimal: allowDecimal)
            : TextInputType.text,
        inputFormatters: onlyDigits
            ? [
                allowDecimal
                    ? FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                    : FilteringTextInputFormatter.digitsOnly
              ]
            : [],
        onTap: onTap,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintext,
          labelText: hasTitle ? title : null,  
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Colors.grey.shade400,
            ),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}