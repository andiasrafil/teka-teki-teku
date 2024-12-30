import 'package:flutter/material.dart';

/// disabled cell (black cell)
class DisabledCell extends StatelessWidget {
  /// constructor
  const DisabledCell({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 10,
      height: MediaQuery.of(context).size.width / 10,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.white),
      ),
    );
  }
}
