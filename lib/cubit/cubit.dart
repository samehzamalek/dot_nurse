//
// Future<int> createDate( Date addDate) async {
//   Database  db = await createDateBase();
//   return db.insert('addDate', addDate.toMap()
//   );
//
// }
// Future<List>allDate()async{
//   Database db=await createDateBase();
//   return db.query('addDate');
// }
// Future<int>dateDelete (int id)async{
//   Database db = await createDateBase();
//   return db.delete('addDate',where: 'id = ?',whereArgs: [id]);
// }
// Future<int>dateUpdate( Date addDate)async{
//   Database db = await createDateBase();
//   return await
//   db.update('addDate', addDate.toMap(),where: 'id=?',whereArgs: [addDate.id]);
// }
//
//
//
//
