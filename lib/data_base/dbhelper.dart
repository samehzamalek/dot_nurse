import 'package:dot_nurse/model/adddate.dart';
import 'package:dot_nurse/model/addmedicine.dart';
import 'package:dot_nurse/model/alarmItem.dart';
import 'package:dot_nurse/model/treatment_cycle.dart';
import 'package:path/path.dart';
 import 'package:sqflite/sqflite.dart';
import '../model/medicine.dart';

final String tableAlarm = 'alarm';
final String columnId = 'id';
final String columnTitle = 'title';
final String columnDateTime = 'alarmDateTime';
// final String columnPending = 'isPending';
// final String columnColorIndex = 'gradientColorIndex';


class DbHelper {
  static final DbHelper _instance = DbHelper.internal();

  factory DbHelper() => _instance;

  DbHelper.internal();

  static Database _db;

  Future<Database> createDateBase() async {
    if (_db != null) {
      return _db;
    }
    String path = join(await getDatabasesPath(), 'dot_nurse.db');
    _db = await openDatabase(path, version: 1,onConfigure:_onConfigure , onCreate: (Database db, int v) {
      db.execute(
          'create table medicines(id integer primary key autoincrement,image text(255),name varchar(50),altName varchar(50),quantity text,expiration text,notes varchar(255))');
      db.execute(
          'create table TreatmentCycle(id integer primary key autoincrement, patientName text(100))');
      db.execute(
          'create table TreatmentCycleMedicine(id integer primary key autoincrement,MedicineId integer,duration text,TreatmentCycleId integer,'
              ''+'foreign key (TreatmentCycleId) references TreatmentCycle(id) ON DELETE CASCADE,'+'foreign key (MedicineId) references medicines(id) ON DELETE CASCADE)');
      db.execute(
          'create table dates(id integer primary key autoincrement , date text,numPerDay text,time text, note text,TreatmentCycleMedicineId integer,'
              ''+'foreign key (TreatmentCycleMedicineId)references TreatmentCycleMedicine(id) ON DELETE CASCADE)');
      // db.execute('''
      //     create table $tableAlarm (
      //     $columnId integer primary key autoincrement,
      //     $columnTitle text not null,
      //     $columnDateTime text not null,
      //
      //   ''');
    });
    return _db;
  }

  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<Treatment> getTreatmentCycle(int id) async{
    Database db = await createDateBase();
    List<Map<String, Object>> lst =  await db.query("TreatmentCycle", where: 'id=?', whereArgs: [id]);
    if(lst.length > 0){
      Treatment treatment = Treatment.fromMap(lst.first);
      List<Map<String, Object>> TreatmentCycleMedicineLst =  await db.query("TreatmentCycleMedicine", where: 'TreatmentCycleId=?', whereArgs: [treatment.id]);
      treatment.TreatmentCycleMedicineList = TreatmentCycleMedicineLst.map((e) => AddMedicine.fromMap(e)).toList();
      for(AddMedicine element in treatment.TreatmentCycleMedicineList){
        List<Map<String, dynamic>> lst = await db.query("medicines", where: 'id=?', whereArgs: [element.MedicineId]);
        List<Medicines> med_lst = lst.map((e) => Medicines.fromMap(e)).toList();
        if(med_lst != null && med_lst.length > 0){
          element.medicine = med_lst.first;
          List<Map<String, Object>> dateList =  await db.query("dates", where: 'TreatmentCycleMedicineId=?', whereArgs: [element.id]);
          element.dateList = dateList.map((e) => Date.fromMap(e)).toList();
        }
      }
      return treatment;
    }else{
      return null;
    }
  }

  Future<List<AddMedicine>> getTreatmentCycleMedicineListWithMedicineReference(List<AddMedicine> lst) async {
    Database db = await createDateBase();
    for(AddMedicine element in lst){
      List<Map<String, dynamic>> lst = await db.query("medicines", where: 'id=?', whereArgs: [element.MedicineId]);
        List<Medicines> med_lst = lst.map((e) => Medicines.fromMap(e)).toList();
        if(med_lst != null && med_lst.length > 0){
          element.medicine = med_lst.first;
          List<Map<String, Object>> dateList =  await db.query("dates", where: 'TreatmentCycleMedicineId=?', whereArgs: [element.id]);
          element.dateList = dateList.map((e) => Date.fromMap(e)).toList();
        }
    }
    return lst;
  }
  /// add medicines
  Future<int> createMedicine(Medicines medicine) async {
    Database db = await createDateBase();
    return db.insert('medicines', medicine.toMap(),conflictAlgorithm:ConflictAlgorithm.replace );
  }

  Future<List> allMedicines() async {
    Database db = await createDateBase();
    return db.query('medicines');
  }

  Future<int> delete(int id) async {
    Database db = await createDateBase();
    return db.delete('medicines', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> medicineUpdate(Medicines medicines) async {
    Database db = await createDateBase();
    return await db.update('medicines', medicines.toMap(),
        where: 'id=?', whereArgs: [medicines.id]);
  }

  ///   create treatment cycle

  void createTreatmentCycle(Treatment treatment,List<AddMedicine>medicineLst) async {
    Database db = await createDateBase();
    int id= await db.insert('TreatmentCycle', treatment.toMap());
    medicineLst.forEach((element) {
      element.setTreatmentCycleId(id);
      this.createTreatmentCycleMedicine(element, element.dateList, id);
      //db.insert('dates', element.toMap());
    });
  }

  Future<List> allTreatmentCycle( ) async {
    Database db = await createDateBase();
    return db.query('TreatmentCycle');
  }

  Future<int> treatmentCycleDelete(int id) async {
    Database db = await createDateBase();
    // List<Map<String, Object>>  lst =  await db.query("TreatmentCycleMedicine", where: 'TreatmentCycleId=?', whereArgs: [id]);
    // List<AddMedicine> TreatmentCycleMedicineList =  lst.map((e) => AddMedicine.fromMap(e)).toList();
    //  TreatmentCycleMedicineList.forEach((element) async{
    //    await deleteTreatmentCycleMedicine(element.id);
    // });
    return await db.delete('TreatmentCycle', where: 'id = ?', whereArgs: [id]);

  }

  Future<int> treatmentCycleUpdate(Treatment treatment) async {
    Database db = await createDateBase();
    return await db.update('TreatmentCycle', treatment.toMap(),
        where: 'id=?', whereArgs: [treatment.id]);
    // List<AddMedicine> lst = this.getTreatmentCycleMedicine();
    // List<AddMedicine> delete_lst = [];
    // List<AddMedicine> update_lst = [];
    // List<AddMedicine> add_lst = [];

  }
  ///  create treatment cycle medicine Date

  Future<int> createTreatmentCycleMedicineDate(Date addDate,int treatmentCycleMedicineId) async {
    Database db = await createDateBase();
    addDate.setTreatmentCycleMedicineId(treatmentCycleMedicineId);
    print('insert');
    return db.insert('dates', addDate.toMap());
  }
  Future<List> allTreatmentCycleMedicineDate() async {
    Database db = await createDateBase();
    return db.query('dates');
  }

  Future<int> treatmentCycleMedicineDateDelete(int id ) async {
    Database db = await createDateBase();
    return await db.delete('dates', where: 'id = ?', whereArgs: [id]);
  }
  Future<int> treatmentCycleMedicineDateUpdate(Date addDate) async {
    Database db = await createDateBase();
    return await db.update('dates', addDate.toMap(),
        where: 'id=?', whereArgs: [addDate.id]);
  }


  ///  create treatment cycle medicine
  // Future<int> createAddMedicine(AddMedicine addMedicine) async {
  //   Database db = await createDateBase();
  //   return db.insert('addMedicine', addMedicine.toMap());
  // }

  List<AddMedicine> getTreatmentCycleMedicine(){
    List<AddMedicine> lst;
     this.allTreatmentCycleMedicine().then((data) {
      lst = data.map((element) {
          return AddMedicine
              .fromMap(element);
        }).toList();
      });
    return lst;
  }

  createTreatmentCycleMedicine(AddMedicine addMedicine, List<Date> addMedicineDates, int treatmentCycleId ) async {
    Database db = await createDateBase();
    addMedicine.TreatmentCycleId= treatmentCycleId;
    // addMedicine.MedicineId = addMedicine.medicine.id;
    int id = await db.insert('TreatmentCycleMedicine', addMedicine.toMap());
    await addMedicineDates.forEach((element) async{
      element.setTreatmentCycleMedicineId(id);
      await db.insert('dates', element.toMap());
    });
  }

  Future<List> allTreatmentCycleMedicine() async {
    Database db = await createDateBase();
    return db.query('TreatmentCycleMedicine');
  }

  Future<int> deleteTreatmentCycleMedicine (int TreatmentCycleMedicineId) async {
    List<Date> dateLst = [];
    Database db = await createDateBase();
    return await allTreatmentCycleMedicineDate().then((data) {
      dateLst = data.map((element) {
        return Date
            .fromMap(element);
      }).toList();
      dateLst = dateLst.where((value) => value.TreatmentCycleMedicineId == TreatmentCycleMedicineId ).toList();
      dateLst.forEach((element) async{
        await treatmentCycleMedicineDateDelete(element.id );
      });
      return  db.delete('TreatmentCycleMedicine', where: 'id = ?', whereArgs: [TreatmentCycleMedicineId]);
    });
  }

  Future<int> treatmentCycleMedicineUpdate(AddMedicine addMedicine) async {
    addMedicine.MedicineId = addMedicine.medicine.id;
    Database db = await createDateBase();
    return await db.update('TreatmentCycleMedicine', addMedicine.toMap(),
        where: 'id=?', whereArgs: [addMedicine.id]);
  }



 /// create alarm
  ///
  // void insertAlarm(AlarmItem alarmInfo) async {
  //   Database db = await createDateBase();
  //   var result = await db.insert(tableAlarm, alarmInfo.toMap());
  //   print('result : $result');
  // }
  //
  // Future<List<AlarmItem>> getAlarms() async {
  //   List<AlarmItem> _alarms = [];
  //
  //   Database db = await createDateBase();
  //   var result = await db.query(tableAlarm);
  //   result.forEach((element) {
  //     var alarmInfo = AlarmItem.fromMap(element);
  //     _alarms.add(alarmInfo);
  //   });
  //
  //   return _alarms;
  // }
  //
  // Future<int> deleteAlarm(int id) async {
  //   Database db = await createDateBase();
  //   return await db.delete(tableAlarm, where: '$columnId = ?', whereArgs: [id]);
  // }


}
