import 'package:flutter/material.dart';

class KindaAppBar extends StatelessWidget {
  const KindaAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              'Recent',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.grey,
            ),
          ],
        ),
        Icon(
          Icons.menu,
          color: Colors.grey,
        ),
      ],
    );
  }
}