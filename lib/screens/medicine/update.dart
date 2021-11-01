
import 'dart:io';

import 'package:dot_nurse/data_base/dbhelper.dart';
import 'package:dot_nurse/model/medicine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../components.dart';
import '../../layout/home_layout.dart';

class MedicineUpDate extends StatefulWidget {
  Medicines medicines;
  MedicineUpDate(this.medicines);

  @override
  _MedicineUpDateState createState() => _MedicineUpDateState();
}

class _MedicineUpDateState extends State<MedicineUpDate> {
  var nameController = TextEditingController();
  var altNameController = TextEditingController();
  var quantityController = TextEditingController();
  var expirationController = TextEditingController();
  var notesController = TextEditingController();
  DbHelper helper;
  DateTime dateTime = DateTime.now();
  final imagePicker = ImagePicker();
  File _image;
  PickedFile image;
  String photo_path;
  @override
  void initState() {
     super.initState();
     helper=DbHelper();
     imagePath=widget.medicines.image;
     nameController.text=widget.medicines.name;
     altNameController.text=widget.medicines.altName;
     quantityController.text=widget.medicines.quantity;
     expirationController.text=widget.medicines.expiration;
     notesController.text=widget.medicines.notes;
  }
  String imagePath;
  Future getImage() async {
    image = await imagePicker.getImage(source: ImageSource.camera);
    setState(() {
      _image = File(image.path);
      print(image.path);
    });
  }
   @override
  Widget build(BuildContext context) {
     File photo= File(imagePath);
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.teal ,
        title: Text('Edit Medicine' ),),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
           children: [
             Stack(
               alignment: AlignmentDirectional.bottomEnd,
               children: [
                 _image == null
                     ? CircleAvatar(
                   backgroundColor: Colors.white,
                   radius: 60,
                   backgroundImage: new FileImage(photo),
                 )
                     : CircleAvatar(
                   backgroundColor: Colors.white,
                   radius: 60,
                   backgroundImage: new FileImage(_image),
                 ),
                 CircleAvatar(

                   backgroundColor: Colors.white,
                   child: IconButton(
                     icon: Icon(
                       Icons.camera_alt,
                       size: 20,
                       color: Colors.teal,
                     ),
                     onPressed: getImage,
                   ),
                 ),
               ],
             ),
             const SizedBox(
               height: 15,
             ),
             TextFormField(
               controller: nameController,
               keyboardType: TextInputType.name,

               decoration: InputDecoration(
                 border: OutlineInputBorder(),
                 labelText: 'Medicine Name ',
               ),
             ),
             const SizedBox(
               height: 15,
             ),
             TextFormField(
               controller: altNameController,
               keyboardType: TextInputType.name,
               decoration: InputDecoration(
                 floatingLabelBehavior: FloatingLabelBehavior.always,
                 border: OutlineInputBorder(),
                 labelText: 'Medicine Alt Name ',
               ),
             ),
             const SizedBox(
               height: 15,
             ),
             TextFormField(
               controller: quantityController,
               keyboardType: TextInputType.number,
               decoration: InputDecoration(
                 border: OutlineInputBorder(),
                 labelText: 'Quantity',
               ),
             ),
             const SizedBox(
               height: 15,
             ),
             TextFormField(
               showCursor: true,
               readOnly: true,
               keyboardType: TextInputType.datetime,
               controller: expirationController,
               onTap: () => showSheet(context, child: buildDatePicker(),
                   onClicked: () {
                     setState(() {
                       expirationController.text = new DateFormat('dd/MM/yyyy').format(dateTime);
                     });
                     Navigator.pop(context);
                   }),
               decoration: InputDecoration(
                   labelText: "Expire Date  ", border: OutlineInputBorder()),
             ),
             const SizedBox(
               height: 15,
             ),
             TextFormField(
               maxLines: 4,
               controller: notesController,
               keyboardType: TextInputType.text,

               decoration: InputDecoration(
                 floatingLabelBehavior: FloatingLabelBehavior.always,
                 border: OutlineInputBorder(),
                 labelText: 'Notes',
               ),
             ),
             const SizedBox(
               height: 25,
             ),
             MaterialButton(
               color: Colors.teal,
               height: 60,
               minWidth: double.infinity,
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
               onPressed: () async {
                 String imagePath_str=imagePath;
                 if(image !=null && image.path != null)
                 {
                   imagePath_str=image.path;
                 }

                 var updatedMedicine=Medicines({
                   'image':imagePath_str,
                   'id':widget.medicines.id,
                   'name':nameController.text,
                   'altName':altNameController.text,
                   'quantity':quantityController.text,
                   'expiration':expirationController.text,
                   'notes':notesController.text,
                 });
                 helper.medicineUpdate(updatedMedicine);
                 navigateAndKill(context, HomeLayout());
               },
               child: Text('Save',style:
                 TextStyle(fontSize: 30,color: Colors.white),),
             )
             // )
           ],
            ),
        ),
      ),

    );
  }
  Widget buildDatePicker() => SizedBox(
    height: 180,
    child: CupertinoDatePicker(
      minimumYear: 2021,
      initialDateTime: dateTime,
      mode: CupertinoDatePickerMode.date,
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
