class ClinicModel {
  final int id;
  final String name;
  final String code;
  final String createdAt;
  final int userCount;
  final int appointmentCount;
  final int queueCount;

  ClinicModel({
    required this.id,
    required this.name,
    required this.code,
    required this.createdAt,
    required this.userCount,
    required this.appointmentCount,
    required this.queueCount,
  });

  factory ClinicModel.fromJson(Map<String, dynamic> json) {
    return ClinicModel(
        id: json['id'],
        name: json['name'],
        code: json['code'],
        createdAt: json['createdAt'],
        userCount: json['userCount'],
        appointmentCount: json['appointmentCount'],
        queueCount: json['queueCount']
    );
  }

  Map<String, dynamic> toJson() {
    return {
    'id':id,
    'name':name,
    'code':code,
    'createAt':createdAt,
    'userCount':userCount,
    'appointmentCount':appointmentCount,
    'queueCount':queueCount
  };
  }
}