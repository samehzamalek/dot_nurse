class  Date {
  int _id;
  String _date;
  String _numPerDay;
  String _note;
  int _TreatmentCycleMedicineId;
  String _time;




  Date(dynamic obj) {
    _id = obj['id'];
    _date = obj['date'];
    _numPerDay = obj['numPerDay'];
    _note = obj['note'];
    _TreatmentCycleMedicineId = obj['TreatmentCycleMedicineId'];
    _time = obj['time'];

   }

 Date.fromMap(Map<String, dynamic> data) {
    _id = data['id'];
    _date = data['date'];
    _numPerDay = data['numPerDay'];
    _note = data['note'];
    _TreatmentCycleMedicineId = data['TreatmentCycleMedicineId'];
    _time = data['time'];

 }

  Map<String, dynamic> toMap() =>
      {
        'id': _id,
        'date': _date,
        'numPerDay': _numPerDay,
         'note': _note,
        'TreatmentCycleMedicineId': _TreatmentCycleMedicineId,
        'time': _time,

      };

  int get id => _id;
  String get date => _date;
  String get numPerDay => _numPerDay;
  String get note => _note;
  int get TreatmentCycleMedicineId => _TreatmentCycleMedicineId;
  String get time => _time;

  void setTreatmentCycleMedicineId(int medicineId){
    this._TreatmentCycleMedicineId = medicineId;
  }

}