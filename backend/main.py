from flask import Flask, jsonify, Response
import cv2
import os
from datetime import datetime

app = Flask(__name__)

# Load cascades for face and eye detection
face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml')
eye_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_eye.xml')

# Directory to save captured images
save_dir = r'backend\captured_faces'
if not os.path.exists(save_dir):
    os.makedirs(save_dir)

# Capture from webcam
cap = cv2.VideoCapture(0)

@app.route('/detect', methods=['GET'])
def detect():
    ret, frame = cap.read()
    if not ret:
        return jsonify({"error": "Failed to capture image"}), 500

    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    faces = face_cascade.detectMultiScale(gray, scaleFactor=1.1, minNeighbors=5)
    result = []

    for (x, y, w, h) in faces:
        # Detect eyes within the face ROI
        roi_gray = gray[y:y + h, x:x + w]
        eyes = eye_cascade.detectMultiScale(roi_gray)

        # Check if two eyes are detected
        if len(eyes) >= 2:
            timestamp = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
            image_path = os.path.join(save_dir, f'face_{timestamp}.jpg')
            cv2.imwrite(image_path, frame[y:y + h, x:x + w])
            result.append({"status": "Face detected", "path": image_path})

    if not result:
        result = [{"status": "No face detected"}]
    return jsonify(result)

@app.route('/stop', methods=['GET'])
def stop():
    cap.release()
    cv2.destroyAllWindows()
    return jsonify({"status": "Camera stopped"})

if __name__ == '__main__':
    app.run(debug=True, host="0.0.0.0", port=5000)

