class Themes {
  int? id;
  int? themeValue;

  Themes({this.id, this.themeValue});

  Themes.fromMap(Map map) {
    this.id = map['id'];
    this.themeValue = map['ThemeValue'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ThemeValue': themeValue,
    };
  }

  @override
  String toString() {
    // TODO: implement toString

    return '$id : $themeValue';
  }
}
