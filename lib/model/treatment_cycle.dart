import 'package:dot_nurse/model/addmedicine.dart';
import 'package:dot_nurse/model/medicine.dart';

class Treatment {
    int _id;
    String _patientName;
    List<AddMedicine> _TreatmentCycleMedicineList;


    List<AddMedicine> get TreatmentCycleMedicineList => _TreatmentCycleMedicineList;

  set TreatmentCycleMedicineList(List<AddMedicine> value) {
    _TreatmentCycleMedicineList = value;
  }

  Treatment (dynamic obj) {
    _id = obj['id'];
      _patientName = obj['patientName'];



  }

     Treatment.fromMap(Map<String, dynamic> data) {
    _id = data['id'];
    _patientName = data['patientName'];
  }

  Map<String, dynamic> toMap() =>
      {
        'id': _id,
         'patientName': _patientName,
      };

  int get id => _id;
  String get patientName => _patientName;

    set patientName(String value) {
    _patientName = value;
  }
}