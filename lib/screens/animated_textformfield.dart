import 'package:agriculture_app/helper/colors.dart';
import 'package:agriculture_app/screens/screen_widgets.dart/app_text.dart';
import 'package:flutter/material.dart';

class AnimatedTextField extends StatefulWidget {
  final String title;
  const AnimatedTextField({Key? key, required this.title}) : super(key: key);

  @override
  _AnimatedTextFieldState createState() => _AnimatedTextFieldState();
}

class _AnimatedTextFieldState extends State<AnimatedTextField> {
  FocusNode _focusNode = FocusNode();
  bool textEditHasFocus = false;
  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        textEditHasFocus = _focusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Container(
            child: TextField(
              focusNode: _focusNode,
              decoration: InputDecoration(
                // hintText: textEditHasFocus ? '' : 'Label',
                // hintStyle: TextStyle(
                //   color: Colors.grey,
                // ),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(),
                contentPadding: EdgeInsets.only(left: 40),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 200),
            left: textEditHasFocus ? 10 : 40,
            top: textEditHasFocus ? -10 : 13,
            child: InkWell(
              onTap: () {
                _focusNode.requestFocus();
              },
              child: Container(
                padding: EdgeInsets.only(left: 3),
                color: Colors.white,
                child: AppText(text: widget.title, color: AppColors.greyColor),
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.only(left: 10),
                color: Colors.transparent,
                child: Icon(Icons.favorite),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
