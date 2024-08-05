class Notemodel {
  String? status;
  List<Data>? data;

  Notemodel({this.status, this.data});

  Notemodel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = (json['data'] as List).map((v) => Data.fromJson(v)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['status'] = status;
    if (data != null) {
      json['data'] = data!.map((v) => v.toJson()).toList();
    }
    return json;
  }
}

class Data {
  int? notesId;
  String? notesTitle;
  String? notesContent;
  String? notesImage;
  int? notesUsers;

  Data({
    this.notesId,
    this.notesTitle,
    this.notesContent,
    this.notesImage,
    this.notesUsers,
  });

  Data.fromJson(Map<String, dynamic> json) {
    notesId = json['notes_id'];
    notesTitle = json['notes_title'];
    notesContent = json['notes_content'];
    notesImage = json['notes_image'];
    notesUsers = json['notes_users'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['notes_id'] = notesId;
    json['notes_title'] = notesTitle;
    json['notes_content'] = notesContent;
    json['notes_image'] = notesImage;
    json['notes_users'] = notesUsers;
    return json;
  }
}
