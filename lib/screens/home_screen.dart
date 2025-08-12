import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pose.dart';
import '../services/api_service.dart';
import '../widgets/servo_slider.dart';
import '../widgets/pose_item.dart';
import './run_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<double> _servoValues = [90, 90, 90, 90, 90, 90];
  List<Pose> _poses = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadPoses();
  }

  Future<void> _loadPoses() async {
    setState(() => _isLoading = true);
    try {
      final poses = await ApiService.getPoses();
      setState(() => _poses = poses);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _savePose() async {
    setState(() => _isLoading = true);
    try {
      final pose = Pose(
        id: 0, // Server will assign ID
        servo1: _servoValues[0].toInt(),
        servo2: _servoValues[1].toInt(),
        servo3: _servoValues[2].toInt(),
        servo4: _servoValues[3].toInt(),
        servo5: _servoValues[4].toInt(),
        servo6: _servoValues[5].toInt(),
      );
      
      await ApiService.savePose(pose);
      await _loadPoses();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pose saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deletePose(int id) async {
    setState(() => _isLoading = true);
    try {
      await ApiService.deletePose(id);
      await _loadPoses();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pose deleted')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _resetSliders() {
    setState(() {
      for (int i = 0; i < _servoValues.length; i++) {
        _servoValues[i] = 90;
      }
    });
  }

  void _runPose() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RunScreen(
          servoValues: _servoValues.map((v) => v.toInt()).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Robot Control')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Servo Sliders
                  for (int i = 0; i < 6; i++)
                    ServoSlider(
                      label: 'Servo ${i + 1}',
                      value: _servoValues[i],
                      onChanged: (value) => setState(() => _servoValues[i] = value),
                    ),
                  
                  const SizedBox(height: 20),
                  
                  // Control Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.restart_alt),
                        label: const Text('Reset'),
                        onPressed: _resetSliders,
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.save),
                        label: const Text('Save Pose'),
                        onPressed: _savePose,
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Run'),
                        onPressed: _runPose,
                      ),
                    ],
                  ),
                  
                  const Divider(height: 40),
                  
                  // Saved Poses
                  const Text(
                    'Saved Poses',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  
                  if (_poses.isEmpty)
                    const Center(child: Text('No poses saved yet')),
                  
                  for (final pose in _poses)
                    PoseItem(
                      pose: pose,
                      onLoad: () {
                        setState(() {
                          _servoValues[0] = pose.servo1.toDouble();
                          _servoValues[1] = pose.servo2.toDouble();
                          _servoValues[2] = pose.servo3.toDouble();
                          _servoValues[3] = pose.servo4.toDouble();
                          _servoValues[4] = pose.servo5.toDouble();
                          _servoValues[5] = pose.servo6.toDouble();
                        });
                      },
                      onDelete: () => _deletePose(pose.id),
                    ),
                ],
              ),
            ),
    );
  }
}