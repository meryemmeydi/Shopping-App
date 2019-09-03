class ShoppingItem extends Comparable {
  final String id;
  final String item;
  bool isComplete;
  final String createdAt;
  final String office;
  final int week;

  ShoppingItem({this.id, this.item, this.isComplete = false,this.createdAt,this.week,this.office});

  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      id: json['_id'],
      item: json['item'],
      createdAt: json['createdAt'],
      office: json['office'],
      week: json['week']
    );
  }
  ShoppingItem.fromMap(Map<String, dynamic> map)
  : id = map["id"],
    item = map["item"],
    isComplete = map["isComplete"] == 1, 
    createdAt =map["createdAt"],
    office=map["office"],
    
    week=map["week"];
  @override
  int compareTo(other) {
    if (this.isComplete && !other.isComplete) {
      return 1;
    } else if (!this.isComplete && other.isComplete) {
      return -1;
    } else {
      return this.id.compareTo(other.id);
    }
  }

    Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "name": item,
      //"isComplete": isComplete ? 1 : 0
    };

    if (id != null) {
      map["id"] = id;
    }
    return map;
  }
}