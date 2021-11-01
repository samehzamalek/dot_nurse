import 'package:dot_nurse/data_base/dbhelper.dart';
import 'package:dot_nurse/layout/home_layout.dart';
import 'package:dot_nurse/model/treatment_cycle.dart';
import 'package:dot_nurse/screens/treatment/treatment_cycle_medicine/update.dart';
import 'package:dot_nurse/screens/treatment/update_treatmentcycle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'add_treatment.dart';
import '../../components.dart';

class TreatmentCycle extends StatefulWidget {
  @override
  _TreatmentCycleState createState() => _TreatmentCycleState();
}

class _TreatmentCycleState extends State<TreatmentCycle> {
  var allPatient = [];
  DbHelper helper;
  var items = List();

  @override
  void initState() {
    super.initState();
    helper = DbHelper();
    helper.allTreatmentCycle().then((data) {
      setState(() {
        allPatient = data;
        items = allPatient;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      helper.allTreatmentCycle();
    });
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.teal,
          onPressed: () {
            navigateTo(context, AddCourse());
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text('Treatment Cycle'),
          backgroundColor: Colors.teal,
        ),
        body: ListView.separated(
            itemBuilder: (context, i) {
              Treatment patient = Treatment.fromMap(items[i]);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          context: context, builder: (BuildContext context) =>
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              width: double.infinity,
                              height: 100,
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      navigateTo(context, UpdateTreatmentCycle(patient));
                                    },
                                    child: Row(
                                      children: [
                                        IconButton(
                                            onPressed: () {


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
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                              title: const Text(
                                                  'Confirm Delete'),
                                              content: const Text(
                                                  'Are you sure you want Delete this item? '),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'Cancel'),
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    print('delete');
                                                    setState(() {
                                                      helper
                                                          .treatmentCycleDelete(
                                                          patient.id);

                                                    });
                                                    navigateAndKill(context, HomeLayout(page: 2,));
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
                    child: Container(
                      height: 80,
                      child: Center(
                        child: Text(
                          '${patient.patientName}',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              );
            },
            separatorBuilder: (context, index) {
              return Container(
                width: double.infinity,
                height: 1,
                color: Colors.teal[100],
              );
            },
            itemCount: items.length)
    );
  }
}
