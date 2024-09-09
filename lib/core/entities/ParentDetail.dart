class ParentDetail {
  String? status;
  String? userName;
  String? parentName;
  String? emailAddress;
  String? mobileNo;

  ParentDetail(
      {this.status,
      this.userName,
      this.parentName,
      this.emailAddress,
      this.mobileNo});

  factory ParentDetail.fromJson(Map<String, dynamic> json) {
    return ParentDetail(
        status: json['Status'],
        userName: json['User_Name'],
        parentName: json['Parent_Name'],
        emailAddress: json['Email_Address'],
        mobileNo: json['Mobile_No']);
  }

  Map<String, dynamic> toJson() {
    return {
      'Status': status,
      'User_Name': userName,
      'Parent_Name': parentName,
      'Email_Address': userName,
      'Mobile_No': mobileNo
    };
  }
}
