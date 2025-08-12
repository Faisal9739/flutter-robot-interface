import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pose.dart';

class ApiService {
  static const String baseUrl = 'http://YOUR_LOCAL_IP/robot_control'; // Change to your XAMPP IP

  // Save pose to server
  static Future<Pose> savePose(Pose pose) async {
    final response = await http.post(
      Uri.parse('$baseUrl/save_pose.php'),
      body: pose.toJson(),
    );

    if (response.statusCode == 200) {
      return Pose.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to save pose');
    }
  }

  // Get all poses
  static Future<List<Pose>> getPoses() async {
    final response = await http.get(Uri.parse('$baseUrl/get_poses.php'));
    
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Pose.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load poses');
    }
  }

  // Delete a pose
  static Future<void> deletePose(int id) async {
    final response = await http.post(
      Uri.parse('$baseUrl/delete_pose.php'),
      body: {'id': id.toString()},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete pose');
    }
  }
}