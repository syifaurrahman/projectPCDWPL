import numpy as np
import cv2
import os
import time
from datetime import datetime

# Load cascade classifier untuk deteksi wajah dan mata
face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml')
eye_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_eye.xml')

# Buka kamera
cap = cv2.VideoCapture(0)

# Tentukan folder penyimpanan gambar
save_dir = r'D:\kuliah\KULIAH PNL\Semester 5\Prak Citra Digital\Project experiment\project shv\captured_faces'
if not os.path.exists(save_dir):
    os.makedirs(save_dir)

# Indeks untuk penamaan file gambar
image_index = 0
max_images = 2  # Batas maksimum gambar yang disimpan

# Variabel untuk menyimpan waktu awal deteksi wajah
start_time = None

# Menaikkan kontras frame dengan faktor 2 (maksimal)
contrast_factor = 2.0

while True:
    # Baca frame dari kamera
    ret, frame = cap.read()

    # Meningkatkan kontras frame
    frame = cv2.convertScaleAbs(frame, alpha=contrast_factor, beta=0)  # alpha = contrast, beta = brightness

    # Menerapkan efek mirror pada frame
    frame = cv2.flip(frame, 1)  # 1 berarti flip horizontal
    
    # Konversi frame ke grayscale
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    
    # Deteksi wajah
    faces = face_cascade.detectMultiScale(gray, scaleFactor=1.1, minNeighbors=5)
    
    if len(faces) > 0:
        # Wajah terdeteksi, mulai hitung waktu jika belum dimulai
        if start_time is None:
            start_time = time.time()    
        
        elapsed_time = time.time() - start_time
        
        # Deteksi mata dalam wajah yang terdeteksi
        for (x, y, w, h) in faces:
            roi_gray = gray[y:y+h, x:x+w]
            roi_color = frame[y:y+h, x:x+w]
            eyes = eye_cascade.detectMultiScale(roi_gray)

            # Jika mata terdeteksi
            if len(eyes) >= 2:  # Mencari setidaknya dua mata
                # Jika telah lebih dari 3 detik, masuk ke hitung mundur
                if elapsed_time > 3:
                    for countdown in range(3, 0, -1):
                        # Tampilkan pesan hitung mundur pada frame
                        frame_copy = frame.copy()
                        cv2.putText(frame_copy, f"Menangkap dalam {countdown}...", (20, 30), cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 255, 255), 2)
                        cv2.putText(frame_copy, f"{image_index + 1} of {max_images}", (20, 60), cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255, 0, 0), 2)
                        cv2.imshow('Deteksi Wajah', frame_copy)
                        cv2.waitKey(1000)
                    
                    # Setelah hitung mundur, ambil wajah terbesar
                    largest_face = max(faces, key=lambda face: face[2] * face[3])
                    (x, y, w, h) = largest_face
                    
                    # Memperluas area penangkapan wajah
                    margin = 20
                    x = max(x - margin, 0)
                    y = max(y - margin, 0)
                    w = min(w + 2 * margin, frame.shape[1] - x)
                    h = min(h + 2 * margin, frame.shape[0] - y)
                    
                    # Ekstrak wajah dari frame asli tanpa garis hijau
                    face_image = frame[y:y+h, x:x+w].copy()
                    
                    # Tambahkan tanggal dan waktu pada gambar
                    current_time = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
                    image_path = os.path.join(save_dir, f'wajah_{current_time}.jpg')
                    cv2.imwrite(image_path, face_image)
                    print(f"Gambar wajah disimpan di: {image_path}")
                    
                    # Tambah jumlah gambar yang telah disimpan
                    image_index += 1
                    
                    # Keluar setelah menyimpan gambar jika sudah mencapai batas
                    if image_index >= max_images:
                        cap.release()
                        cv2.destroyAllWindows()
                        print("Maksimal gambar tercapai. Program ditutup.")
                        exit()  # Keluar dari program
                    
                    # Reset waktu
                    start_time = None
                    break
            else:
                # Reset waktu jika tidak ada mata terdeteksi
                start_time = None
                cv2.putText(frame, "Mata tidak terdeteksi, harap posisikan wajah dengan jelas", (20, 30), cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 0, 255), 2)

            # Gambarlah kotak merah di sekitar mata yang terdeteksi
            for (ex, ey, ew, eh) in eyes:
                cv2.rectangle(roi_color, (ex, ey), (ex + ew, ey + eh), (0, 0, 255), 2)  # Warna merah
            
        # Tampilkan pesan hitung mundur mulai
        if start_time is not None:
            cv2.putText(frame, "Hitung mundur dimulai...", (20, 30), cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 255, 0), 2)
            cv2.putText(frame, f"{image_index} of {max_images}", (20, 60), cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255, 0, 0), 2)
    
    else:
        # Reset waktu jika tidak ada wajah terdeteksi
        start_time = None
        cv2.putText(frame, "Harap posisikan wajah dengan jelas", (20, 30), cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 0, 255), 2)
    
    # Tampilkan frame dengan kotak hijau (hanya untuk tampilan, tidak disimpan)
    for (x, y, w, h) in faces:
        cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 255, 0), 2)
    
    # Tampilkan frame
    cv2.putText(frame, f"{image_index} of {max_images}", (20, 60), cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255, 0, 0), 2)
    cv2.imshow('Deteksi Wajah', frame)
    
    # Keluar jika tombol 'q' ditekan    
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# Tutup kamera dan jendela
cap.release()
cv2.destroyAllWindows()
