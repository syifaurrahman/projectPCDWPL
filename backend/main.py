import numpy as np
import cv2
import os
from datetime import datetime
from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

class FaceDetector:
    def __init__(self):
        self.face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml')
        self.eye_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_eye.xml')
        self.save_dir = r'D:\flutter app\projectPCDWPL\backend\wajah'
        
        if not os.path.exists(self.save_dir):
            os.makedirs(self.save_dir)

    def process_frame(self, frame):
        gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        faces = self.face_cascade.detectMultiScale(gray, scaleFactor=1.1, minNeighbors=5)
        
        result = []
        saved_face = False
        
        for (x, y, w, h) in faces:
            roi_gray = gray[y:y+h, x:x+w]
            eyes = self.eye_cascade.detectMultiScale(roi_gray)
            
            face_data = {
                "status": "Face detected",
                "bounding_box": {
                    "x": int(x),
                    "y": int(y),
                    "w": int(w),
                    "h": int(h)
                },
                "eyes": [],
                "saved": False
            }
            
            if len(eyes) >= 2:
                face_data["status"] = "Face and eyes detected"
                for (ex, ey, ew, eh) in eyes:
                    face_data["eyes"].append({
                        "x": int(x + ex),
                        "y": int(y + ey),
                        "w": int(ew),
                        "h": int(eh)
                    })
                
                if not saved_face:
                    margin = 20
                    x_save = max(x - margin, 0)
                    y_save = max(y - margin, 0)
                    w_save = min(w + 2 * margin, frame.shape[1] - x_save)
                    h_save = min(h + 2 * margin, frame.shape[0] - y_save)
                    
                    face_image = frame[y_save:y_save+h_save, x_save:x_save+w_save].copy()
                    current_time = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
                    image_path = os.path.join(self.save_dir, f'wajah_{current_time}.jpg')
                    cv2.imwrite(image_path, face_image)
                    
                    face_data["status"] = "Face captured and saved"
                    face_data["saved"] = True
                    saved_face = True
            else:
                face_data["status"] = "Face detected, positioning eyes..."
                
            result.append(face_data)
            
        if not result:
            result.append({
                "status": "No face detected", 
                "bounding_box": None,
                "eyes": [],
                "saved": False
            })
            
        return result

detector = FaceDetector()

@app.route('/detect', methods=['POST'])
def detect():
    if 'image' not in request.files:
        return jsonify({"error": "No image provided"}), 400
        
    image_file = request.files['image']
    nparr = np.frombuffer(image_file.read(), np.uint8)
    frame = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
    
    if frame is None:
        return jsonify({"error": "Invalid image"}), 400
        
    result = detector.process_frame(frame)
    return jsonify(result)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
