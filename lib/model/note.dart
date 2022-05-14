class Note {
  final String title;
  final String note;
  String key;
  int timestamp;
  String noteColor;
  // List<dynamic>? images;
  Map<dynamic, dynamic>? images;
  Note(this.key, this.title, this.note, this.timestamp, this.noteColor,
      {this.images});

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'title': title,
        'note': note,
        'key': key,
        'timestamp': timestamp,
        'noteColor': noteColor,
      };

  Note.fromJson(Map<dynamic, dynamic> json)
      : title = json['title'] as String,
        note = json['note'] as String,
        key = json['key'] as String,
        timestamp = json['timestamp'] as int,
        noteColor = json['noteColor'] as String,
        // images = json['images'] as List<dynamic>;
        images = json['images'] as Map<dynamic, dynamic>;
}
