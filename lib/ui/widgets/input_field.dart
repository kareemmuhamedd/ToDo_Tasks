import 'package:flutter/material.dart';
import 'package:todo/ui/theme.dart';
import '../size_config.dart';
import 'package:get/get.dart';

class InputField extends StatefulWidget {
  final String title;
  final String hint;
  final double? height;
  final TextEditingController? contruller;
  final Widget? widget;

  const InputField({
    Key? key,
    required this.title,
    required this.hint,
    this.contruller,
    this.widget,
    this.height,
  }) : super(key: key);

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      margin: const EdgeInsets.only(top: 16),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: titleStyle,
          ),
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.only(left: 14),
            width: SizeConfig.screenWidth,
            height: widget.height ?? 53,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey)),
            alignment: Alignment.center,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    cursorColor:
                        Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
                    autofocus: false,
                    controller: widget.contruller,
                    readOnly: widget.widget == null ? false : false,
                    style: subTitleStyle,
                    decoration: InputDecoration(
                      hintText: widget.hint,
                      hintStyle: subTitleStyle,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            width: 0,
                            color: Theme.of(context).colorScheme.background),
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.background)),
                    ),
                  ),
                ),
                widget.widget ?? Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
