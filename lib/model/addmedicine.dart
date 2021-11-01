import 'package:dot_nurse/model/adddate.dart';
import 'package:dot_nurse/model/medicine.dart';

class  AddMedicine {
  int _id;
  String _duration;
  List<Date>_dateList;
  int _TreatmentCycleId;
  int _MedicineId;


  set TreatmentCycleId(int value) {
    _TreatmentCycleId = value;
  }

  Medicines _medicine;


  AddMedicine(dynamic obj) {
    _id = obj['id'];

    _duration = obj['duration'];
    _TreatmentCycleId = obj['TreatmentCycleId'];
    _dateList = obj['dateList'];
    _MedicineId = obj['MedicineId'];


  }

  AddMedicine.fromMap(Map<String, dynamic> data) {
    _id = data['id'];

    _duration = data['duration'];

    _TreatmentCycleId = data['TreatmentCycleId'];

    _MedicineId = data['MedicineId'];
  }

  Map<String, dynamic> toMap() =>
      {
        'id': _id,
        'duration': _duration,
        'TreatmentCycleId': _TreatmentCycleId,
        'MedicineId': _MedicineId,


      };

  int get id => _id;
  int get TreatmentCycleId => _TreatmentCycleId;

  String get duration => _duration;
  int get MedicineId => _MedicineId;



  set id(int value) {
    _id = value;
  }


  Medicines get medicine => _medicine;

  set medicine(Medicines value) {
    _medicine = value;
  }

  List<Date> get dateList => _dateList;

  void setDateList(List<Date> list){
    this._dateList = list;
  }
  void setTreatmentCycleId(int id ){
    this._TreatmentCycleId = id;
  }




  set duration(String value) {
    _duration = value;
  }


  set dateList(List<Date> value) {
    _dateList = value;
  }



  set MedicineId(int value) {
    _MedicineId = value;
  }
}