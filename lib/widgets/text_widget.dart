import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {Key? key,
      required this.textController,
      required this.hintText,
      this.obscure = false,
      this.textInputType = TextInputType.text,
      this.maxLength = 100,
      this.onChange,
      this.focusNode})
      : super(key: key);

  final TextEditingController textController;
  final String hintText;
  final bool obscure;
  final FocusNode? focusNode;
  final TextInputType textInputType;
  final int maxLength;
  final Function(String)? onChange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextFormField(
        scrollPadding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        focusNode: focusNode,
        autofocus: false,
        controller: textController,
        maxLines: obscure ? 1 : null,
        maxLength: maxLength,
        onChanged: onChange,
        keyboardType: textInputType,
        cursorColor: Colors.white,
        style: Theme.of(context).textTheme.titleMedium,
        obscureText: obscure,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.transparent,
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.bodySmall,
          // fillColor: Color(0xff4E4E4E),
          // fillColor: Color(0xff222222),
          enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.secondary),
              borderRadius: BorderRadius.circular(30)),
          focusedBorder: OutlineInputBorder(
              // borderSide: const BorderSide(color: Color(0xff4E4E4E)),
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.primary),
              borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }
}
