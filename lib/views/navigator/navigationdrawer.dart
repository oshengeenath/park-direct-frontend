// ignore_for_file: use_super_parameters
import 'package:flutter/material.dart';
class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context),
            buildMenuItems(context),
          ],
        )),
      );
  Widget buildHeader(BuildContext context) => Material(
      color: Colors.blue.shade700,
      child: InkWell(
          onTap: () {},
          child: Container(
              color: const Color.fromARGB(255, 3, 0, 33),
              padding: EdgeInsets.only(
                top: 24 + MediaQuery.of(context).padding.top,
                bottom: 24,
              ),
              child: const Column(
                children: [
                  CircleAvatar(
                    radius: 52,
                    backgroundImage: AssetImage('assets/profile.png'),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    'Sadeepa Ranasinghe',
                    style: TextStyle(fontSize: 28, color: Colors.white),
                  ),
                  Text(
                    'sadeepa@gmail.com',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  )
                ],
              ))));
  Widget buildMenuItems(BuildContext context) => Container(
        padding: const EdgeInsets.all(24),
        child: Wrap(runSpacing: 16, children: [
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Farm'),
            onTap: () {
              Navigator.pop(context);

            },
          ),
          ListTile(
              leading: const Icon(Icons.update),
              title: const Text('Animal sitting'),
              onTap: () {
                Navigator.pop(context);

              }),
          ListTile(
            leading: const Icon(Icons.attach_money),
            title: const Text('AI Process'),
            onTap: () {
              Navigator.pop(context);

            },
          ),
          ListTile(
            leading: const Icon(Icons.receipt),
            title: const Text('Animal Diseases'),
            onTap: () {
              Navigator.pop(context);

            },
          ),
          ListTile(
            leading: const Icon(Icons.landscape),
            title: const Text('Farm Expenses'),
            onTap: () {
              Navigator.pop(context);

            },
          ),
          ListTile(
            leading: const Icon(Icons.business_center),
            title: const Text('Monthly Income'),
            onTap: () {
              Navigator.pop(context);

             },
          ),
          
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('Daily Dairy'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.power_settings_new,
              color: Colors.red,
            ),
            title: const Text(
              'Log Out',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ]),
      );
}