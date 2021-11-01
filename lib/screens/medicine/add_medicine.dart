 import 'dart:io';
import 'package:dot_nurse/layout/home_layout.dart';
  import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../components.dart';
import '../../data_base/dbhelper.dart';
import '../../model/medicine.dart';

class AddMedicine extends StatefulWidget {
  @override
  _AddMedicineState createState() => _AddMedicineState();
}


class _AddMedicineState extends State<AddMedicine> {
  bool _visible = false;
  void _toggle() {
    setState(() {
      _visible = !_visible;
    });
  }
  var nameController = TextEditingController();
  var altNameController = TextEditingController();
  var quantityController = TextEditingController();
  var expirationController = TextEditingController();
  var notesController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  DateTime dateTime = DateTime.now();
  DbHelper helper;
  File _image;
  final imagePicker = ImagePicker();
  PickedFile image;


  Future getImage() async {
    image = await imagePicker.getImage(source: ImageSource.camera);
    setState(() {
      _image = File(image.path);
      print(image.path);
    });
  }

  @override
  void initState() {
    super.initState();
    helper = DbHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Add Medicine'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    _image == null
                        ? CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 60,
                            backgroundImage: AssetImage('images/image.jpg'),
                          )
                        : CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 60,
                            backgroundImage: new FileImage(_image,),
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
                Visibility(
                  child: Text("image is required",style: TextStyle(color: Colors.red),),
                  visible: _visible,
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Medicine Name is required ';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.teal,width:1.5,),),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
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
                    focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.teal,width:1.5)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                    labelText: 'Medicine Alt Name ',
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'quantity is required ';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.teal,width:1.5)),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
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
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Expire Date is required ';
                    }
                    return null;
                  },
                  controller: expirationController,
                  onTap: () => showSheet(context, child: buildDatePicker(),
                      onClicked: () {
                    setState(() {
                      expirationController.text = new DateFormat('dd/MM/yyyy').format(dateTime);
                    });
                    Navigator.pop(context);
                  }),
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.teal,width:1.5)),
                      labelText: "Expire Date",
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20)))),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  maxLines:3,
                  controller: notesController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.teal,width:1.5),),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  onPressed: () async {
                    // upload();
                    if (formKey.currentState.validate() && image!=null) {
                      Medicines m = Medicines({
                        'image': image.path,
                        'name': nameController.text,
                        'altName': altNameController.text,
                        'quantity': quantityController.text,
                        'expiration': expirationController.text,
                        'notes': notesController.text,
                      });
                      //int id = await helper.createMedicine(m);
                      helper.createMedicine(m);
                      navigateAndKill(context, HomeLayout());
                    }
                    else{
                      setState(() {
                        _visible=true;
                      });


                    }
                  },
                  child: Text('Save'
                  ,style:TextStyle(color: Colors.white,fontSize:30 ) ,),
                )
                // )
              ],
            ),
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
