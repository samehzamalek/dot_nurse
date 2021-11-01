import 'dart:io';
import 'dart:ui';
import 'package:dot_nurse/data_base/dbhelper.dart';
import 'package:dot_nurse/noti/noti.dart';
import 'package:dot_nurse/screens/medicine/detail.dart';
import 'package:dot_nurse/layout/home_layout.dart';
import 'package:dot_nurse/screens/medicine/update.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_medicine.dart';
import '../../components.dart';
import '../../model/medicine.dart';
var allData = [];
class MedicinesScreen extends StatefulWidget {
  @override
  _MedicinesScreenState createState() => _MedicinesScreenState();
}

class _MedicinesScreenState extends State<MedicinesScreen> {
  var allMedicines = [];
  DbHelper helper;
  var items=List();

  @override
  void initState() {
    super.initState();
    helper = DbHelper();
    helper.allMedicines().then((data) {
      setState(() {
        allMedicines = data;
        allData=data;
        items=allMedicines;
        print(allData);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    {
      setState(() {
        helper.allMedicines();
      });
    }
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.teal,
          onPressed: () {
            navigateTo(context, AddMedicine());
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text('Medicines'),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    showSearch(
                        context: context, delegate: DataSearch(allMedicines));
                  });
                },
                icon: Icon(Icons.search)),


          ],
        ),
        body:   ListView.separated(
          itemBuilder: (context, i) {
            Medicines medicine = Medicines.fromMap(items[i]);
            String imagePath = "${medicine.image}";
            File image = File(imagePath);
            return Padding(
                padding: const EdgeInsets.all(10.0),
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) => Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            child: Column(
                              children: [

                                InkWell(
                                  onTap: () {
                                    navigateTo(context,
                                        MedicineUpDate(medicine));
                                  },
                                  child: Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            navigateTo(
                                                context,
                                                MedicineUpDate(
                                                    medicine));
                                          },
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.green,
                                          )),
                                      const Text('Edit ')
                                    ],
                                  ),
                                ),

                                InkWell(
                                  onTap: () {
                                    navigateTo(
                                        context,
                                        DetailScreen(
                                            medicines: medicine));
                                  },
                                  child: Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            navigateTo(
                                                context,
                                                DetailScreen(
                                                    medicines:
                                                    medicine));
                                          },
                                          icon: Icon(
                                            Icons.details,
                                            color: Colors.green,
                                          )),
                                      const Text('Details')
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    showDialog<String>(
                                      context: context,
                                      builder:
                                          (BuildContext context) =>
                                          AlertDialog(
                                            title: const Text(
                                                'Confirm Delete'),
                                            content: const Text(
                                                'Are you sure you want Delete this item? '),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context,
                                                        'Cancel'),
                                                child:
                                                const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    helper.delete(medicine.id);
                                                    navigateTo(context, HomeLayout());
                                                  });
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          ),
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.green,
                                          )),
                                      const Text('Delete ')
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ));
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 30,
                        backgroundImage: new FileImage(image),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${medicine.name}',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              '${medicine.altName}',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              'Quantity : ${medicine.quantity}',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        children: [
                          Text(
                            'Expire Date',
                            style: TextStyle(color: Colors.red[400]),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            '${medicine.expiration}',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ));
          },
          separatorBuilder: (context, index) {
            return Container(
              width: double.infinity,
              height: 1,
              color: Colors.teal[100],
            );
          },
          itemCount:items.length,
          padding: EdgeInsetsDirectional.only(bottom: 33),
        )


    );
  }
}

class DataSearch extends SearchDelegate {
  final List<dynamic> search_lst;
  List<String> lst;

  DataSearch(@required this.search_lst) {
    lst = search_lst.map((element) {
      return Medicines.fromMap(element).name;
    }).toList();
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(Icons.close))
    ];
  }

  @override
  void showResults(BuildContext context) {
    _saveToRecentSearches(query);
    super.showResults(context);
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List filternames = lst.where((element) => element.startsWith(query)).toList();
    DbHelper helper;

    return ListView.separated(
        itemBuilder: (context, index) {

          Medicines medicines = Medicines.fromMap(allData[index]);
          List<Medicines> med =
              search_lst.map((e) => Medicines.fromMap(e)).toList();
          List<Medicines> filtered = med.where((ele) {
            return filternames.contains(ele.name);
          }).toList();
          var medicine = filtered[index];
          String imagePath = "${medicine.image}";
          File image = File(imagePath);

          return Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) =>
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              width: double.infinity,
                              height: 150,
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      navigateTo(
                                          context, MedicineUpDate(medicine));
                                    },
                                    child: Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              navigateTo(
                                                  context,
                                                  DetailScreen(
                                                      medicines: medicine));
                                            },
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.green,
                                            )),
                                        const Text('Edit ')
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      navigateTo(context,
                                          DetailScreen(medicines: medicine));
                                    },
                                    child: Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              navigateTo(
                                                  context,
                                                  DetailScreen(
                                                      medicines: medicine));
                                            },
                                            icon: Icon(
                                              Icons.details,
                                              color: Colors.green,
                                            )),
                                        const Text('Details')
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          title: const Text('Confirm Delete'),
                                          content: const Text(
                                              'Are you sure you want Delete this item? '),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  context, 'Cancel'),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                print('delete');
                                                helper.delete(medicine.id);
                                                navigateTo(
                                                    context, HomeLayout());
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.green,
                                            )),
                                        const Text('Delete ')
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ));
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                      backgroundImage: new FileImage(image),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${medicine.name}',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                          // const SizedBox(
                          //   height: 1,
                          // ),
                          Text(
                            '${medicine.altName}',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w200),
                          ),
                          // const SizedBox(
                          //   height: 7,
                          // ),
                          Text(
                            '${medicine.quantity}',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      children: [
                        Text(
                          'Expire Date',
                          style: TextStyle(color: Colors.red[400]),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          '${medicine.expiration}',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    // IconButton(onPressed: () {
                    //   setState(() {
                    //     helper.delete(medicine.id);
                    //     // print('${medicine.id}');
                    //   });
                    // }, icon: Icon(Icons.delete, color: Colors.teal,)),
                  ],
                ),
              ));
        },
        separatorBuilder: (context, index) {
          return Container();
        },
        itemCount: filternames.length);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List filternames = lst.where((element) => element.contains(query)).toList();
    return ListView.builder(
        itemCount: query == "" ? lst.length : filternames.length,
        itemBuilder: (context, i) {
          return InkWell(
            onTap: () {
              showResults(context);
            },
            child: Container(
                padding: EdgeInsets.all(10),
                child: query == ""
                    ? Text("${lst[i]}")
                    : Text("${filternames[i]}")),
          );
        });
  }

  Future<void> _saveToRecentSearches(String searchText) async {
    if (searchText == null) return; //Should not be null
    final pref = await SharedPreferences.getInstance();

    //Use `Set` to avoid duplication of recentSearches
    List<String> allSearches = pref.getStringList('.medicineHistory') ?? [];

    //Place it at first in the set
    allSearches.add(searchText);
    pref.setStringList('.medicineHistory', allSearches.toList());
  }
}
