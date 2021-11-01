import 'package:dot_nurse/data_base/dbhelper.dart';
import 'package:dot_nurse/model/adddate.dart';
import 'package:dot_nurse/model/medicine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../components.dart';
import 'add_medicine_course.dart';

class AddDate extends StatefulWidget {
  const AddDate({Key key, @required this.duration, @required this.onDateSet,this.editMode=false,this.treatmentCycleMedicineId})
      : super(key: key);
  final int duration;
  final Function(Date) onDateSet;
  final bool editMode;
  final int treatmentCycleMedicineId;

  @override
  _AddDateState createState() => _AddDateState();
}

class _AddDateState extends State<AddDate> {
  DateTime dateTime = DateTime.now();
  DbHelper helper;
  String _valueChoose;
  String newValue;
  List listItem = [
    "Other",
    "Morning",
    "Evening",
    "Before Eating",
    "After Eating",
    "Before Breakfast",
    "after Breakfast",
    "Before Lunch",
    "After Lunch",
    "Before Dinner",
    "After Dinner",
  ];
  var formKey = GlobalKey<FormState>();
  var dateController = TextEditingController();
  var timeController = TextEditingController();

  var numberPerDayController = TextEditingController();
  var otherNoteController = TextEditingController();
  bool _visible = false;
  bool _autovalidate = false;
  bool visible = false;

  void _toggle() {
    setState(() {
      _visible = !_visible;
    });
  }

  void toggle() {
    setState(() {
      visible = !visible;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    helper = DbHelper();
  }

  Medicines newMed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text('Add Date'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              autovalidate: _autovalidate,
              child: Column(
                children: [
                  Image(
                    image: AssetImage(
                      'images/date.png',
                    ),
                    fit: BoxFit.cover,
                    height: 200,
                    width: 200,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'number per day is required ';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      labelText: 'Number Per Day',
                    ),
                    controller: numberPerDayController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    showCursor: true,
                    readOnly: true,
                    keyboardType: TextInputType.datetime,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Date is required ';
                      }
                      return null;
                    },
                    onTap: () => showSheet(context, child: buildDatePicker(),
                        onClicked: () {
                      setState(() {
                        dateController.text =
                            new DateFormat('dd/MM/yyyy').format(dateTime);
                      });
                      Navigator.pop(context);
                    }),
                    decoration: InputDecoration(
                        labelText: "Start Date",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30)))),
                    controller: dateController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    showCursor: true,
                    readOnly: true,
                    keyboardType: TextInputType.datetime,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Time is required ';
                      }
                      return null;
                    },
                    onTap: () => showSheet(context, child: buildTimePicker(),
                        onClicked: () {
                      setState(() {
                        timeController.text =
                            new DateFormat.jm().format(dateTime);
                      });
                      Navigator.pop(context);
                    }),
                    decoration: InputDecoration(
                        labelText: "Time",
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30)))),
                    controller: timeController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField(
                      decoration: InputDecoration(
                          labelText: 'Note',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)))),
                      validator: (value) =>
                          value == null ? 'Note is required' : null,
                      iconSize: 22,
                      isExpanded: true,
                      value: _valueChoose,
                      onChanged: (newValue) {
                        if (newValue == 'Other') {
                          _visible = true;
                        }
                        setState(() {
                          _valueChoose = newValue;
                        });
                      },
                      items: listItem.map((valueItem) {
                        return DropdownMenuItem(
                          value: valueItem,
                          child: Text(valueItem),
                        );
                      }).toList()),
                  const SizedBox(
                    height: 25,
                  ),
                  Visibility(
                    visible: _visible,
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        labelText: 'Other Note',
                      ),
                      controller: otherNoteController,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  MaterialButton(
                    height: 40,
                    minWidth: 200,
                    color: Colors.teal,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    onPressed: () {
                      String choose;
                      if (_valueChoose == 'Other') {
                        choose = otherNoteController.text;
                      } else {
                        choose = _valueChoose;
                      }
                      if (formKey.currentState.validate()) {
                        Date date = Date({
                          'date': dateController.text,
                          'numPerDay': numberPerDayController.text,
                          'note': choose,
                          'time': timeController.text
                        });
                        if(widget.editMode&&widget.treatmentCycleMedicineId!=null){
                          helper.createTreatmentCycleMedicineDate(date,widget.treatmentCycleMedicineId);
                        }

                        setState(() {
                          widget.onDateSet(date);

                        });
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget buildDatePicker() => SizedBox(
        height: 180,
        child: CupertinoDatePicker(
          minimumYear: dateTime.year,
          maximumYear: dateTime.add(Duration(days: widget.duration)).year,
          minimumDate: dateTime,
          maximumDate: dateTime.add(Duration(days: widget.duration)),
          initialDateTime: dateTime,
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: (dateTime) {
            return setState(() => this.dateTime = dateTime);
          },
        ),
      );

  Widget buildTimePicker() => SizedBox(
        height: 180,
        child: CupertinoDatePicker(
          initialDateTime: dateTime,
          mode: CupertinoDatePickerMode.time,
          onDateTimeChanged: (dateTime) {
            return setState(() => this.dateTime = dateTime);
          },
        ),
      );

  static void showSheet(
    BuildContext context, {
    @required Widget child,
    @required VoidCallback onClicked,
  }) =>
      showCupertinoModalPopup(
          context: context,
          builder: (context) => CupertinoActionSheet(
                actions: [
                  child,
                ],
                cancelButton: CupertinoActionSheetAction(
                  child: Text('Done'),
                  onPressed: onClicked,
                ),
              ));
}
