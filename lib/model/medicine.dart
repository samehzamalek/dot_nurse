class Medicines {
  int _id;
  String _image;
  String _name;
  String _altName;
  String _expiration;
  String _quantity;
  String _notes;


  Medicines(dynamic obj) {
    _id = obj['id'];
    _image = obj['image'];
    _name = obj['name'];
    _altName = obj['altName'];
    _expiration = obj['expiration'];
    _quantity = obj['quantity'];
    _notes = obj['notes'];

  }

  Medicines.fromMap(Map<String, dynamic> data) {
    _id = data['id'];
    _image = data['image'];
    _name = data['name'];
    _altName = data['altName'];
    _expiration = data['expiration'];
    _quantity = data['quantity'];
    _notes = data['notes'];

  }

  Map<String, dynamic> toMap() => {
        'id': _id,
        'image': _image,
        'name': _name,
        'altName': _altName,
        'expiration': _expiration,
        'quantity': _quantity,
        'notes': _notes,

  };

  int get id => _id;

  String get image => _image;

  String get name => _name;

  String get altName => _altName;

  String get expiration => _expiration;

  String get quantity => _quantity;

  String get notes => _notes;
}


