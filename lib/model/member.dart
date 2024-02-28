class Member {
  String? memId;
  String? memUsername;
  String? memFullname;
  String? memPassword;
  String? memEmail;
  String? memAge;
  String? message;

  Member(
      {this.memId,
      this.memUsername,
      this.memFullname,
      this.memPassword,
      this.memEmail,
      this.memAge,
      this.message});

  Member.fromJson(Map<String, dynamic> json) {
    memId = json['memId'];
    memFullname = json['memFullname'];
    memUsername = json['memUsername'];
    memPassword = json['memPassword'];
    memEmail = json['memEmail'];
    memAge = json['memAge'];
    message = json['message'];
  }

  get id => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imemId'] = this.memId;
    data['memFullname'] = this.memFullname;
    data['memUsername'] = this.memUsername;
    data['memPassword'] = this.memPassword;
    data['memEmail'] = this.memEmail;
    data['memAge'] = this.memAge;
    data['message'] = this.message;
    return data;
  }
}
