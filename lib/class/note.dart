class Note {
  int? _id;
  String? _title;
  String? _description;
  String? _date;

  // Default constructor
  Note(this._title, this._date, [this._description = '']);

  // Constructor with id
  Note.withId(this._id, this._title, this._date, [this._description = '']);

  // Empty constructor
  Note.empty()
      : _title = '',
        _description = '',
        _date = '';

  // Getters
  int? get id => _id;
  String get title => _title!;
  String get description => _description!;
  String get date => _date!;

  // Setters
  set title(String newTitle) {
    if (newTitle.length <= 255) {
      _title = newTitle;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 255) {
      _description = newDescription;
    }
  }

  set date(String newDate) {
    _date = newDate;
  }

  // Convert a Note into a Map object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (_id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['date'] = _date;
    return map;
  }

  // Extract a Note object from a Map object
  Note.fromMapObject(Map<String, dynamic> map) {
    _id = map['id'];
    _title = map['title'];
    _description = map['description'];
    _date = map['date'];
  }
}
