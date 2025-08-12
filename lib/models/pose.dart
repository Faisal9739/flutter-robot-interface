class Pose {
  final int id;
  final int servo1;
  final int servo2;
  final int servo3;
  final int servo4;
  final int servo5;
  final int servo6;

  Pose({
    required this.id,
    required this.servo1,
    required this.servo2,
    required this.servo3,
    required this.servo4,
    required this.servo5,
    required this.servo6,
  });

  factory Pose.fromJson(Map<String, dynamic> json) {
    return Pose(
      id: json['id'],
      servo1: json['servo1'],
      servo2: json['servo2'],
      servo3: json['servo3'],
      servo4: json['servo4'],
      servo5: json['servo5'],
      servo6: json['servo6'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'servo1': servo1,
      'servo2': servo2,
      'servo3': servo3,
      'servo4': servo4,
      'servo5': servo5,
      'servo6': servo6,
    };
  }
}