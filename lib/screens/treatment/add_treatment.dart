import 'dart:io';
import 'package:dot_nurse/components.dart';
import 'package:dot_nurse/layout/home_layout.dart';
 import 'package:dot_nurse/model/addmedicine.dart';
import 'package:dot_nurse/model/alarmItem.dart';
import 'package:dot_nurse/model/treatment_cycle.dart';
import 'package:dot_nurse/screens/treatment/treatment_cycle.dart';
 import 'package:dot_nurse/screens/treatment/treatment_cycle_medicine/update.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
 import '../../data_base/dbhelper.dart';
import '../../main.dart';
import 'treatment_cycle_medicine/add_medicine_course.dart';

class AddCourse extends StatefulWidget {
  @override
  _AddCourseState createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  var nameController = TextEditingController();
  var form = GlobalKey<FormState>();
  var formKey = GlobalKey<FormState>();
  DbHelper helper;
  // var allAddMedicine = [];
  // var items=List();
  List<AddMedicine>addedMedicines=[];
  @override
  void initState() {
    super.initState();
    helper = DbHelper();
    // helper.allAddMedicine().then((data) {
    //   setState(() {
    //      allAddMedicine= data;
    //      items=allAddMedicine;
    //      print(addedMedicines.length);
    //     // print(allAddMedicine);
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:Text('Add Treatment Cycle') ,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
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
                            return  navigateTo(context,  AddMedicineCourse(
                              onMedicineAdd:(medicine){
                              setState(() {
                                addedMedicines.add(medicine);
                                print(addedMedicines.length);
                              });

                            },));
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
                        child: ListView.separated(
                          itemBuilder: (context, i) {
                            AddMedicine add =addedMedicines[i];
                            String imagePath = "${add.medicine.image}";
                            File image = File(imagePath);
                            Text altName;

                              if(add.medicine.altName==null){
                                altName=  Text('');
                              }
                              else{
                                altName= Text(
                                  '${add.medicine.altName}',
                                  style: TextStyle(
                                    fontSize: 14,color: Colors.grey
                                  ),
                                );
                              }


                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: InkWell(
                                onTap:(){
                                  navigateTo(context, AddMedicineUpdate(addMedicine: add,onMedicineUpdated: (medicine){},));
                                  print(imagePath);

                                },
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 30,
                                    backgroundImage: new FileImage(image),
                                    ),
                                    const SizedBox(
                                      width: 15,),
                                    Text(
                                      '${add.medicine.name}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,

                                      ),
                                    ),
                                    const SizedBox(
                                      width: 40,),
                                    altName,

                                    Spacer(),
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
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
                                                            addedMedicines.removeAt(i);
                                                          });
                                                          Navigator.pop(context,
                                                              'Cancel');
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
                          },
                          itemCount: addedMedicines.length,
                          separatorBuilder: (context, index) {
                            return Container(
                              width: double.infinity,
                              height: 1,
                              color: Colors.teal[100],
                            );
                          },
                        )
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  color: Colors.teal,
                  height: 60,
                  minWidth:250,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  onPressed: () {
                    if (formKey.currentState.validate()) {
                      Treatment  patient = Treatment ({
                        'patientName':nameController.text,
                      });
                      //int id = await helper.createMedicine(m);
                      setState(() {
                        helper.createTreatmentCycle(patient,addedMedicines);
                        /// generate Alarm list
                        List<AlarmItem>alarmlist=generateAlarmList(addedMedicines);
                        setAlarm(alarmlist);
                        navigateAndKill(context,HomeLayout(page: 2,));
                      });
                    }
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
      ),
    );
  }
  generateAlarmList(List<AddMedicine> addedMedicines){
    List<AlarmItem> lst =new List<AlarmItem>();

    addedMedicines.forEach((medicineElement) {
      List<String> date_patterns = medicineElement.dateList[0].date.split('/');
      List<String> time_patterns = medicineElement.dateList[0].time.split(":");
      DateTime medicineDateTime = new DateTime(int.parse(date_patterns[2]), int.parse(date_patterns[1]), int.parse(date_patterns[0]),
          int.parse(time_patterns[0]), );
      for(int i=0;i<int.parse(medicineElement.duration) ;i++){
        medicineElement.dateList.forEach((dateElement) {
          double seed = 24 / int.parse(dateElement.numPerDay);
         for(int y=0;y<int.parse(dateElement.numPerDay);y++){
           AlarmItem item = new AlarmItem();
           item.title = medicineElement.medicine.name;
           print(medicineElement.medicine.name);
           item.alarmDateTime= medicineDateTime;
           lst.add(AlarmItem());
           medicineDateTime.add(Duration(hours: seed.toInt()));
         }
        });
      }
    });
    return lst;
  }
  // void scheduleAlarm  (
  //     // DateTime scheduledNotificationDateTime, AlarmInfo alarmInfo
  //     ) async {
  //   var scheduledNotificationDateTime=DateTime.now().add(Duration(seconds: 20));
  //   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //     'alarm_notif',
  //     'alarm_notif',
  //     'Channel for Alarm notification',
  //     icon: 'codex_logo',
  //     sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
  //     largeIcon: DrawableResourceAndroidBitmap('codex_logo'),
  //   );
  //
  //   var iOSPlatformChannelSpecifics = IOSNotificationDetails(
  //       sound: 'a_long_cold_sting.wav',
  //       presentAlert: true,
  //       presentBadge: true,
  //       presentSound: true);
  //   var platformChannelSpecifics = NotificationDetails(
  //       androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  //
  //   await flutterLocalNotificationsPlugin.schedule(0, nameController.text, 'Good morning',
  //       scheduledNotificationDateTime, platformChannelSpecifics);
  // }

  void setAlarm(List<AlarmItem> alarmlist)async {
    alarmlist.forEach((element) async {
      // DateTime medicineDateTime =  element.alarmDateTime;
      String title=element.title;
      print(element.title);
      var scheduledNotificationDateTime=DateTime.now().add(Duration(seconds: 10));
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'alarm_notif',
        'alarm_notif',
        'Channel for Alarm notification',
        icon: 'codex_logo',
        sound: RawResourceAndroidNotificationSound('zamalek'),
        largeIcon: DrawableResourceAndroidBitmap('codex_logo'),
      );

      var iOSPlatformChannelSpecifics = IOSNotificationDetails(
          sound: 'zamalek',
          presentAlert: true,
          presentBadge: true,
          presentSound: true);
      var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.schedule(0,title, title,
          scheduledNotificationDateTime, platformChannelSpecifics);

    });
  }

}




