import 'package:flutter/material.dart';

import '../../constants.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int pagedx = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: ((index) {
          setState(() {
            pagedx = index;
          });
        }),
        currentIndex: pagedx,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home , size: 25,
            
            ),
            label: ""
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 25 ,

            ),
            label: ""
          ),
          
          BottomNavigationBarItem(
            icon: Icon(Icons.add , size: 25,

            ),
            label : ""
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 25,

            ) ,
            label : ""
          ),
        
        ],
      ),
      body: pageindex[pagedx],
    );
  }
}