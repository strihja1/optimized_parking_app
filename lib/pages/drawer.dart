import 'package:flutter/material.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          AppBar(
            title: const Text('Menu'),
            backgroundColor: Colors.blue,
          ),
          ListTile(
            title: const Text('Hlavní strana'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          ListTile(
            title: const Text('Rovnoměrné nabíjení'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/equalityCharging');
            },
          ),
          ListTile(
            title: const Text('Nabíjení založené na čase'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/timeBasedCharging');
            },
          ),
        ],
      ),
    );
  }
}