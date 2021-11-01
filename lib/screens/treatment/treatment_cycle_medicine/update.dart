import 'package:dot_nurse/data_base/dbhelper.dart';
import 'package:dot_nurse/model/adddate.dart';
import 'package:dot_nurse/model/addmedicine.dart';
import 'package:dot_nurse/model/medicine.dart';
import 'package:dot_nurse/screens/treatment/add_treatment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../components.dart';
import 'add_date.dart';

class AddMedicineUpdate extends StatefulWidget {
  AddMedicine addMedicine;

  AddMedicineUpdate({this.addMedicine,@required this.onMedicineUpdated});

  Function(AddMedicine) onMedicineUpdated;


  @override
  _AddMedicineUpdateState createState() => _AddMedicineUpdateState();
}

class _AddMedicineUpdateState extends State<AddMedicineUpdate> {
  var durationController = TextEditingController();

  DbHelper helper;
  List<Medicines>  items;
  Medicines _select;
  List<Date> date_lst = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    helper = DbHelper();
    setState(() {
      helper.allMedicines().then((data) {
        setState(() {
          items = data.map((element) {
            return Medicines
                .fromMap(element);
          }).toList();
          _select = items.firstWhere((element) => element.id == widget.addMedicine.MedicineId);
        });
      });

      durationController.text = widget.addMedicine.duration;
      date_lst=widget.addMedicine.dateList;

    });


  }

  Medicines newMed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text('Edit'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              child: Column(
                children: [
                  // Container(
                  //   child: DropdownButton(
                  //       hint: Text('Select Medicine:'),
                  //       iconSize: 36,
                  //       isExpanded: true,
                  //       underline: SizedBox(),
                  //       value: _select,
                  //       onChanged: (newValue) {
                  //         setState(() {
                  //           _select = newValue;
                  //           newMed = allMedicines.firstWhere((element) => element.name == newValue);
                  //         });
                  //       },
                  //       items: items != null
                  //           ? items.map((valueItem) {
                  //         return DropdownMenuItem(
                  //           value: valueItem,
                  //           child: Text(valueItem),
                  //         );
                  //       }).toList()
                  //           : []),
                  //   padding: EdgeInsets.only(left: 16, right: 16),
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(20),
                  //       border: Border.all(width: 1, color: Colors.grey)),
                  // ),
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
                          labelText: 'Medicine',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)))),
                      iconSize: 22,
                      isExpanded: true,
                      value: _select,
                      onChanged: (newValue) {
                        setState(() {
                          _select = newValue;
                          // newMed = allMedicines.firstWhere(
                          //     (element) => element.name == newValue);
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
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
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
                            return navigateTo(
                                context,
                                AddDate(
                                  editMode: true,
                                  treatmentCycleMedicineId: widget.addMedicine.id,
                                  duration: convertToInt(),
                                  onDateSet: (date) {
                                    setState(() {
                                      date_lst.add(date);
                                     });
                                  },
                                ));
                          },
                          child: Text(
                            'Add Date',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                        Container(
                            width: double.infinity,
                            height: 170,
                            child: ListView.separated(
                                itemBuilder: (context, i) {
                                  Date date = date_lst[i];
                                  String format = '${date.date}';

                                  DateTime parseDate =
                                      new DateFormat("dd/MM/yyyy")
                                          .parse(format);
                                  var inputDate =
                                      DateTime.parse(parseDate.toString());
                                  var outputFormat = DateFormat.EEEE();
                                  var outputDate =
                                      outputFormat.format(inputDate);

                                  return Container(
                                    padding: EdgeInsets.only(top: 5),
                                    height: 50,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              child: Text(
                                                '${date.numPerDay}',
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              maxRadius: 14,
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
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              '${date.date}',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width:19 ,
                                          child: IconButton(

                                              onPressed: () {
                                                setState(() {
                                                  helper.treatmentCycleMedicineDateDelete (date.id);
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
                                itemCount: date_lst.length))
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
                    onPressed:
                        () {
                      // var addMedicineUpdate=AddMedicine({
                      //   'id':widget.addMedicine.id,
                      //   'nameMedicine':newMed.name,
                      //   'duration':durationController.text,
                      //   'image':newMed.image,
                      //   'altName':newMed.altName,
                      //   'dateList':date_lst,
                      // });
                      setState(() {
                        widget.addMedicine.duration = durationController.text;
                        widget.addMedicine.dateList=date_lst;
                        widget.addMedicine.medicine = _select;
                        widget.addMedicine.MedicineId = _select.id;
                        helper.treatmentCycleMedicineUpdate(widget.addMedicine);
                        widget.onMedicineUpdated(widget.addMedicine);
                        Navigator.pop(context);

                      });
                        },
                    child: Text(
                      'Save',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  convertToInt() {
    if (durationController.text == null || durationController.text == "") {
      return 0;
    }
    return int.parse(durationController.text);
  }
}
