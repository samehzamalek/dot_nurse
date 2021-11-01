
 import 'package:dot_nurse/screens/profile.dart';
 import 'package:dot_nurse/screens/treatment/treatment_cycle.dart';
import 'package:flutter/material.dart';
import '../data_base/dbhelper.dart';
import '../screens/medicine/medicines.dart';
class HomeLayout extends StatefulWidget {

  const HomeLayout({Key key, this.page = 0}) : super(key: key);

  @override
  _HomeLayoutState createState() => _HomeLayoutState();

  final int page;
}

class _HomeLayoutState extends State<HomeLayout> {
    DbHelper helper;
    static List allMedicines = [];
    int currentIndex;
    List<Widget> screens = [
      MedicinesScreen(),
      ProfileScreen(),
      TreatmentCycle(),
    ];

    @override
  void initState() {
    super.initState();
    helper=DbHelper();
    setState(() {
      currentIndex = widget.page;
    });
    // helper.allMedicines().then((data) {
    //   setState(() {
    //     allMedicines = data;
    //
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
          return Scaffold(
            body:screens[currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              selectedItemColor:Colors.white,
              backgroundColor: Colors.teal[300],
              currentIndex: currentIndex,
              onTap: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: 'Profile'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.medical_services),
                    label: 'treatment Cycle'),
              ],
            ),



          );
        }


  }

