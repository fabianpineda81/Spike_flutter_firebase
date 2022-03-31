

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class CustomCardType1 extends StatelessWidget {
  const CustomCardType1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      child: Column(
        children: [
          const ListTile(
            leading: Icon(
              Icons.access_time_filled_rounded,
              color: AppTheme.primary,
            ),
            title: Text("soy un titulo"),
            subtitle: Text(
                "esto es una texto muy largo jajajajaj para ver que poner jajajd"),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () => {}, child: const Text("ok"),),
                TextButton(onPressed: () => {}, child: const Text("cancel")),
              ],
            ),
          )
        ],
      ),
    );
  }
}
