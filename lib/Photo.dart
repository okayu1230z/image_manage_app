class Photo {
  int id;
  String photo_data;

  Photo(this.id, this.photo_data);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'photo_data': photo_data,
    };
    return map;
  }

  Photo.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    photo_data = map['photo_data'];
  }
}
