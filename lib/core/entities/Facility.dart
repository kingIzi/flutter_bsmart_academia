class Facility {
  int facilityRegSno;
  String facilityName;

  Facility({required this.facilityName, required this.facilityRegSno});

  factory Facility.fromJson(Map<String, dynamic> json) {
    return Facility(
        facilityRegSno: json['Facility_Reg_Sno'],
        facilityName: json['Facility_Name']);
  }

  Map<String, dynamic> toJson() {
    return {'Facility_Reg_Sno': facilityRegSno, 'Facility_Name': facilityName};
  }
}
