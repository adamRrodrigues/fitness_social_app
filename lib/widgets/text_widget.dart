import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {Key? key,
      required this.textController,
      required this.hintText,
      this.obscure = false,
      this.focusNode})
      : super(key: key);

  final TextEditingController textController;
  final String hintText;
  final bool obscure;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: TextFormField(
        scrollPadding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        focusNode: focusNode,
        autofocus: false,
        controller: textController,
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
              borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
              // borderSide: const BorderSide(color: Color(0xff4E4E4E)),
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.secondary),
              borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
