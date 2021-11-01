import 'package:dot_nurse/data_base/dbhelper.dart';
import 'package:dot_nurse/model/adddate.dart';
import 'package:dot_nurse/model/addmedicine.dart';
import 'package:dot_nurse/model/medicine.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../components.dart';
import '../add_treatment.dart';
import 'add_date.dart';

class AddMedicineCourse extends StatefulWidget {
  const AddMedicineCourse({Key key,@required this.onMedicineAdd, this.editMode = false, this.treatmentCycleId}) : super(key: key);
  final Function(AddMedicine) onMedicineAdd;
  final bool editMode;
  final int treatmentCycleId;

  @override
  _AddMedicineCourseState createState() => _AddMedicineCourseState();
}

class _AddMedicineCourseState extends State<AddMedicineCourse> {
  var durationController = TextEditingController();
  DateTime dateTime = DateTime.now();
  Medicines _select;
  List<Medicines> allMedicines = [];
  var allData = [];
  var allDate = List();
  List<Medicines> items;
  DbHelper helper;
  var FormKey = GlobalKey<FormState>();
  List<Date> date_lst = [];

  @override
  void initState() {
    super.initState();
    helper = DbHelper();
    // helper.allDate().then((data) {
    //   date_lst = data.map((element) {
    //     return Date.fromMap(element);
    //   }).toList();
    //    setState(() {
    //     allData = data;
    //     allDate = allData;
    //    });
    // });
    helper.allMedicines().then((data) {
      setState(() {
        allMedicines = data.map((element) {
          return Medicines
              .fromMap(element);
        }).toList();
        items = data.map((element) {
          return Medicines
              .fromMap(element);

        }).toList();
      });
    });


  }

  Medicines newMed;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.teal,
          title:Text('Add Medicine') ,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key:FormKey ,
              child: Column(
                children: [
                  Image(
                    image: AssetImage(
                      'images/medicine.png',
                    ),
                    fit: BoxFit.cover,
                    height: 200,
                    width: 200,
                  ),
                  DropdownButtonFormField(
                      decoration: InputDecoration(
                          labelText:'Medicine' ,
                          border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(30)))
                      ),

                      iconSize: 22,
                      isExpanded: true,
                      validator: (value) => value == null ? 'Medicine is required' : null,
                      value: _select,
                      onChanged: (newValue) {
                        setState(() {
                           _select = newValue;
                        });
                      },
                      items: items != null
                          ? items.map((valueItem) {
                        return DropdownMenuItem(
                          value: valueItem,
                          child: Text(valueItem.name),
                        );
                      }).toList()
                          : []),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: durationController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Duration is required ';

                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(30))),
                      labelText: 'Duration',
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.grey,
                        )),
                    padding: EdgeInsetsDirectional.all(10),
                    child: Column(
                      children: [
                        MaterialButton(
                          color: Colors.teal,
                          minWidth: 130,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          onPressed: () {
                            return navigateTo(context, AddDate(duration: convertToInt(),
                              onDateSet: (date){
                                setState(() {
                                  date_lst.add(date);

                                });
                              },));
                          },
                          child: Text(
                            'Add Date',
                            style:
                            TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                        Container(
                            width: double.infinity,
                            height: 170,
                            child:  ListView.separated(
                                itemBuilder: (context, i) {
                                  // Date date = Date.fromMap(snap.data[i]);
                                  Date date = date_lst[i];
                                  String format=  '${date.date}';

                                  DateTime parseDate =
                                  new DateFormat("dd/MM/yyyy").parse(format);
                                  var inputDate = DateTime.parse(parseDate.toString());
                                  var outputFormat = DateFormat.EEEE();
                                  var outputDate = outputFormat.format(inputDate);

                                  return Container(
                                    padding: EdgeInsets.only(top: 5),
                                    height: 50,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [

                                            CircleAvatar(
                                              child: Text(
                                                '${date.numPerDay}',
                                                style:
                                                TextStyle(fontSize: 12),
                                              ),
                                              maxRadius:14,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Expanded(
                                            child: Text(
                                              '${date.note} ',
                                              style: TextStyle(fontSize: 12),
                                            )),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              ' $outputDate',
                                              style:
                                              TextStyle(fontSize: 12),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              '${date.date}',
                                              style:
                                              TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width:19 ,
                                          child: IconButton(

                                              onPressed: () {
                                                setState(() {
                                                  date_lst.removeAt(i);

                                                });
                                              },
                                              icon: Icon(Icons.clear,size: 12,),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return Container(
                                    width: double.infinity,
                                    height: 1,
                                    color: Colors.teal[100],
                                  );
                                },
                                itemCount: date_lst.length)
                        )
                      ],
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
                    onPressed: (){
                      if (FormKey.currentState.validate()) {
                        AddMedicine add = AddMedicine({
                          'duration':durationController.text.toString(),
                          'dateList':date_lst,
                         'medicineId':_select.id,
                        });
                        add.MedicineId=_select.id;
                        if(widget.editMode && widget.treatmentCycleId != null){
                          add.MedicineId=_select.id;
                          helper.createTreatmentCycleMedicine(add, date_lst, widget.treatmentCycleId);
                        }
                        add.medicine = _select;
                       widget.onMedicineAdd(add);
                        Navigator.pop(context);
                      }
                    }
                    ,child: Text('Save',style: TextStyle(color: Colors.white,fontSize: 20),),)
                ],
              ),
            ),
          ),
        )
    );
  }

  convertToInt() {
    if (durationController.text == null || durationController.text == "") {
      return 0;
    }
    return int.parse(durationController.text);
  }
}