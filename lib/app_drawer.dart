import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: const [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              "Menu",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: null, // Add navigation logic here
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
            onTap: null, // Add navigation logic here
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text("About"),
            onTap: null, // Add navigation logic here
          ),
        ],
      ),
    );
  }
}
