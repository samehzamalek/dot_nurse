
import 'dart:io';

import 'package:dot_nurse/model/medicine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class DetailScreen extends StatefulWidget {
  const DetailScreen({
    Key key,
    @required this.medicines
  }) : super(key: key);

   final Medicines medicines;

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {


  @override
  void initState() {
    // TODO: implement initState
    print("Name ====>" + widget.medicines.name);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    String  imagePath = "${widget.medicines.image}";
    File image= File(imagePath);
    return Scaffold(
      appBar: AppBar(
        title:Text('Details') ,

        backgroundColor: Colors.teal,),
      body:Padding(

        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Container(
              //   height: 150,
              //   width: double.infinity,
              //   decoration:new BoxDecoration(
              //     image: new DecorationImage(
              //      image: new FileImage(image),
              //       fit:BoxFit.cover
              //     ),
              //   ),
              // ),
              InkWell(
                onTap:(){
                  return showDialog(
                  context: context, builder: (BuildContext context) {
                    return
                   Container(
                    height: 150,
                     width: double.infinity,
                    decoration:new BoxDecoration(
                       image: new DecorationImage(
                         image: new FileImage(image),
                        fit:BoxFit.cover
                      ),
                    ),
                  );
                }

                  );
                },

                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 70,
                  backgroundImage: new FileImage(image),
                ),
              ),
              const SizedBox(
                height:15 ,
              ),
              TextFormField(
                 decoration: InputDecoration(
                   disabledBorder: OutlineInputBorder(
                     borderSide: const BorderSide(color: Colors.teal,width:2 ),
                   ),
                  labelText: "Medicine Name ",
                     labelStyle: TextStyle(color: Colors.teal,fontWeight:FontWeight.bold )
                ),
                enabled: false,
                initialValue: widget.medicines.name,
              ),
              const SizedBox(
                height:15 ,
              ),
              TextFormField(
                decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,

                    disabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.teal,width:2 ),
                  ),
                  labelText: "Medicine Alt Name ",
                    labelStyle: TextStyle(color: Colors.teal,fontWeight:FontWeight.bold )

                ),
                enabled: false,
                initialValue: widget.medicines.altName,

              ),
              const SizedBox(
                height:15 ,
              ),
              TextFormField(
                decoration: InputDecoration(

                    disabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.teal,width:2 ),
                    ),
                  labelText: "Quantity",
                    labelStyle: TextStyle(color: Colors.teal,fontWeight:FontWeight.bold )

                ),
                enabled: false,
                initialValue: widget.medicines.quantity,
              ),
              const SizedBox(
                height:15 ,
              ),
              TextFormField(
                decoration: InputDecoration(
                  disabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.teal,width:2 ),
              ),
                  labelText: "Expire Date",
                    labelStyle: TextStyle(color: Colors.teal,fontWeight:FontWeight.bold )
                ),
                enabled: false,
                initialValue: widget.medicines.expiration,
              ),
              const SizedBox(
                height:15 ,
              ),
              TextFormField(
                maxLines: 6,
                decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  disabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.teal,width:2 ),
                  ),
                  labelText: "Notes",
                    labelStyle: TextStyle(color: Colors.teal,fontWeight:FontWeight.bold )

                ),
                enabled: false,
                initialValue: widget.medicines.notes,
              ),
              const SizedBox(
                height:15 ,
              ),
            ],
          ),
        ),
      )

    );
  }
}
