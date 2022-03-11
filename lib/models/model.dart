class BankApp {
  String? id;
  String? username;
  String? svv;
  String? cardnumber;
  String? date;

  BankApp({this.id, this.username,this.cardnumber,this.date,this.svv});

  BankApp.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    svv = json['svv'];
    cardnumber = json['cardnumber'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data ={};
    data['id'] = id;
    data['username'] = username;
    data['svv'] = svv;
    data['cardnumber'] = cardnumber;
    data['date'] = date;
    return data;
  }
}