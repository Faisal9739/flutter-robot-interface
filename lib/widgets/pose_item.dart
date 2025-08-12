import 'package:flutter/material.dart';
import '../models/pose.dart';

class PoseItem extends StatelessWidget {
  final Pose pose;
  final VoidCallback onLoad;
  final VoidCallback onDelete;

  const PoseItem({
    super.key,
    required this.pose,
    required this.onLoad,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('Pose #${pose.id}'),
        subtitle: Text(
          'S1: ${pose.servo1}°  S2: ${pose.servo2}°  S3: ${pose.servo3}°\n'
          'S4: ${pose.servo4}°  S5: ${pose.servo5}°  S6: ${pose.servo6}°',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: onLoad,
              tooltip: 'Load Pose',
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
              tooltip: 'Delete Pose',
            ),
          ],
        ),
      ),
    );
  }
}