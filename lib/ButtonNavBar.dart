import 'package:flutter/material.dart';
import 'package:projet/AjoutActivity.dart';
import 'package:projet/ListActivite.dart';
import 'package:projet/MyProfile.dart';

class MyNavBarButtom extends StatefulWidget {
  const MyNavBarButtom({Key? key}) : super(key: key);

  @override
  State<MyNavBarButtom> createState() => _MyNavBarButtomState();
}

class _MyNavBarButtomState extends State<MyNavBarButtom> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ListeActivite(),
    const AjoutActivity(),
    const ProfileWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 30,
              color: _currentIndex == 0
                  ? const Color.fromRGBO(85, 105, 254, 1.0)
                  : Colors.grey,
            ),
            label: "Activité ",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add,
              color: _currentIndex == 1
                  ? const Color.fromRGBO(85, 105, 254, 1.0)
                  : Colors.grey,
              size: 30,
            ),
            label: "Ajouter",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: _currentIndex == 2
                  ? const Color.fromRGBO(85, 105, 254, 1.0)
                  : Colors.grey,
              size: 30,
            ),
            label: "profile",
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            print(index);
          });
        },
      ),
      body: _pages[_currentIndex],
    );
  }
}
