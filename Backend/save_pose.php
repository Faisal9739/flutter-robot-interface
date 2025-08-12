<?php
include 'db_connect.php';

// Enable CORS
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

// Get POST data
$input = file_get_contents('php://input');
$data = json_decode($input, true);

// If JSON decode fails, try form data
if (!$data) {
    $data = $_POST;
}

// Validate and cast to integers
$servo1 = isset($data['servo1']) ? (int)$data['servo1'] : 90;
$servo2 = isset($data['servo2']) ? (int)$data['servo2'] : 90;
$servo3 = isset($data['servo3']) ? (int)$data['servo3'] : 90;
$servo4 = isset($data['servo4']) ? (int)$data['servo4'] : 90;
$servo5 = isset($data['servo5']) ? (int)$data['servo5'] : 90;
$servo6 = isset($data['servo6']) ? (int)$data['servo6'] : 90;

// Validate range
$servo1 = min(max($servo1, 0), 180);
$servo2 = min(max($servo2, 0), 180);
$servo3 = min(max($servo3, 0), 180);
$servo4 = min(max($servo4, 0), 180);
$servo5 = min(max($servo5, 0), 180);
$servo6 = min(max($servo6, 0), 180);

// Insert new pose
$stmt = $conn->prepare("INSERT INTO poses (servo1, servo2, servo3, servo4, servo5, servo6) VALUES (?, ?, ?, ?, ?, ?)");
$stmt->bind_param("iiiiii", $servo1, $servo2, $servo3, $servo4, $servo5, $servo6);

if ($stmt->execute()) {
    $id = $stmt->insert_id;
    echo json_encode([
        'success' => true,
        'id' => $id,
        'servo1' => $servo1,
        'servo2' => $servo2,
        'servo3' => $servo3,
        'servo4' => $servo4,
        'servo5' => $servo5,
        'servo6' => $servo6
    ]);
} else {
    echo json_encode(['success' => false, 'error' => $conn->error]);
}

$stmt->close();
$conn->close();
?>