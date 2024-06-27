class Sectiondetailmodel {
  int? sectionId ;
  String? count ;
  String? description ;
  String? reference ;
  String? content ;
  Sectiondetailmodel(this.sectionId,this.count,this.description,
  this.reference,this.content);

  Sectiondetailmodel.fromJson(Map<String,dynamic>json) {
    sectionId = json["section_id"];
    count = json["count"];
    description = json["description"];
    reference = json["reference"];
    content = json["content"];
  }
}