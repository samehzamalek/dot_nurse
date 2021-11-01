import 'dart:io';
import 'package:dot_nurse/data_base/dbhelper.dart';
import 'package:dot_nurse/layout/home_layout.dart';
import 'package:dot_nurse/model/addmedicine.dart';
import 'package:dot_nurse/model/treatment_cycle.dart';
import 'package:dot_nurse/screens/treatment/treatment_cycle_medicine/add_medicine_course.dart';
import 'package:dot_nurse/screens/treatment/treatment_cycle_medicine/update.dart';
import 'package:flutter/material.dart';
import '../../components.dart';

class UpdateTreatmentCycle extends StatefulWidget {
  Treatment treatment;
  UpdateTreatmentCycle(this.treatment);

  @override
  _UpdateTreatmentCycleState createState() => _UpdateTreatmentCycleState();
}

class _UpdateTreatmentCycleState extends State<UpdateTreatmentCycle> {
  var nameController = TextEditingController();
  Treatment allTreatment;
  List<AddMedicine> addedMedicines;
  DbHelper helper;

  @override
  void initState() {
    super.initState();
    helper = DbHelper();

    // setState(() {
    helper.getTreatmentCycle(widget.treatment.id).then((value) {
      // setState(() {
        if(value!=null){
          setState(() {
            allTreatment = value;
            nameController.text = value.patientName;
            addedMedicines = value.TreatmentCycleMedicineList;
          });
        }

      // });
    });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Add Treatment Cycle'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Image(
                image: AssetImage(
                  'images/patient.png',
                ),
                fit: BoxFit.cover,
                height: 200,
                width: 200,
              ),
              TextFormField(
                controller: nameController,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'name is required';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.teal,
                      width: 1.5,
                    ),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  labelText: 'Patient Name ',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.grey,
                    )),
                padding: EdgeInsetsDirectional.all(3),
                child: Column(
                  children: [
                    MaterialButton(
                        color: Colors.teal,
                        minWidth: 150,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onPressed: () {
                          return navigateTo(
                              context,
                              AddMedicineCourse(
                                editMode: true,
                                treatmentCycleId: allTreatment.id,
                                onMedicineAdd: (medicine) {
                                  setState(() {
                                    addedMedicines.add(medicine);

                                  });
                                },
                              ));
                        },
                        child: Text(
                          'Add',
                          style: TextStyle(color: Colors.white),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                        height: 300,
                        child:
                        ListView.separated(
                          itemBuilder: (context, i) {

                            AddMedicine add = addedMedicines[i];
                            // if(add.medicine!=null){
                              String imagePath = "${add.medicine.image}";
                              File image = File(imagePath);
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: InkWell(
                                  onTap: () {
                                    navigateTo(
                                        context,
                                        AddMedicineUpdate(
                                            addMedicine: add,
                                            onMedicineUpdated: (medicine) {
                                              setState(() {
                                                add = medicine;
                                              });
                                            }));

                                  },
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 30,
                                        backgroundImage: new FileImage(image),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(

                                        '${add.medicine.name}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(
                                        width: 40,
                                      ),
                                      Text(
                                        '${add.medicine.altName}',
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      Spacer(),
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
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
                                                            setState(() {
                                                              helper
                                                                  .deleteTreatmentCycleMedicine(
                                                                  add.id);
                                                              addedMedicines
                                                                  .removeAt(i);
                                                            });
                                                            Navigator.pop(
                                                                context, 'Cancel');
                                                          },
                                                          child: const Text('OK'),
                                                        ),
                                                      ],
                                                    ),
                                              );
                                            });
                                          },
                                          icon: Icon(Icons.clear))
                                    ],
                                  ),
                                ),
                              );

                            // }
                            // else{
                            //   return Center(child: CircularProgressIndicator());
                            // }

                          },
                          itemCount: addedMedicines != null ? addedMedicines.length : 0,
                          separatorBuilder: (context, index) {
                            return Container(
                              width: double.infinity,
                              height: 1,
                              color: Colors.teal[100],
                            );
                          },
                        )

                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                color: Colors.teal,
                height: 60,
                minWidth: 250,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                onPressed: () {
                  setState(() {
                    var updateTreatmentCycle =
                        Treatment({

                          'id':   widget.treatment.id,
                          'patientName': nameController.text});
                    helper.treatmentCycleUpdate(updateTreatmentCycle);
                    navigateAndKill(context, HomeLayout(page: 2,));
                  });
                },
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
