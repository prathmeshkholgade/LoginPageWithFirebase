import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool loading;
  const RoundButton({
    super.key,
    this.title = "random",
    required this.onTap,
    required this.loading,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child:
              loading
                  ? CircularProgressIndicator()
                  : Text(title, style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
