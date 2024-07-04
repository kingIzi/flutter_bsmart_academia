class GetSDetail {
  int? facilityRegSno;
  String? facilityName;
  String? userName;
  String? parentName;
  String? admissionNo;
  int? classSno;
  String? className;
  int? sectionSno;
  String? sectionName;
  int? academicSno;
  String? acadYear;
  String? sFullName;

  GetSDetail({
    this.facilityRegSno,
    this.facilityName,
    this.userName,
    this.parentName,
    this.admissionNo,
    this.classSno,
    this.className,
    this.sectionSno,
    this.sectionName,
    this.academicSno,
    this.acadYear,
    this.sFullName,
  });

  // Factory method to create an instance from JSON
  factory GetSDetail.fromJson(Map<String, dynamic> json) {
    return GetSDetail(
      facilityRegSno: json['Facility_Reg_Sno'],
      facilityName: json['Facility_Name'],
      userName: json['User_Name'],
      parentName: json['Parent_Name'],
      admissionNo: json['Admission_No'],
      classSno: json['Class_Sno'],
      className: json['Class_Name'],
      sectionSno: json['Section_Sno'],
      sectionName: json['Section_Name'],
      academicSno: json['Academic_Sno'],
      acadYear: json['Acad_Year'],
      sFullName: json['SFullName'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'Facility_Reg_Sno': facilityRegSno,
      'Facility_Name': facilityName,
      'User_Name': userName,
      'Parent_Name': parentName,
      'Admission_No': admissionNo,
      'Class_Sno': classSno,
      'Class_Name': className,
      'Section_Sno': sectionSno,
      'Section_Name': sectionName,
      'Academic_Sno': academicSno,
      'Acad_Year': acadYear,
      'SFullName': sFullName,
    };
  }
}
