# Tutorial 7 Gamedev - Sistem Interaksi 3D FPS

## Fitur-fitur yang Diimplementasikan

### 1. Sistem Item & Inventori
Saya telah mengimplementasikan sistem inventori yang memungkinkan pemain untuk:
- Mengambil objek di dunia game menggunakan tombol interaksi (E)
- Menyimpan objek dalam inventori yang dapat diakses dengan tombol "I"
- Menggunakan objek langsung dari inventori
- Objek akan menghilang dari dunia game ketika diambil

**Implementasi:**
- Membuat kelas dasar Interactable.gd dengan metode `pickup()` dan `interact()`
- Sistem inventori dalam Player.gd menyimpan referensi item dalam array
- InventoryUI.gd menampilkan item dalam inventori dengan nama dan deskripsi
- InventoryItem.gd menangani interaksi objek dari dalam inventori

### 2. Mekanik Pergerakan Pemain
Saya menambahkan berbagai opsi pergerakan pada controller FPS:
- **Sprinting:** Tahan Shift untuk berlari lebih cepat
- **Crouching:** Tahan Ctrl untuk jongkok, memperkecil tinggi pemain dan mengurangi kecepatan
- **Deteksi Rintangan:** Pemain tidak bisa berdiri saat berada di bawah langit-langit yang rendah

**Implementasi:**
- Menggunakan variabel `speed`, `sprint_speed`, dan `crouch_speed` dalam Player.gd
- Fungsi `is_ceiling_above()` untuk deteksi langit-langit menggunakan raycasting
- Transisi halus antara posisi normal dan jongkok dengan `lerp()`

### 3. Objek Interaktif
Saya membuat berbagai elemen interaktif dalam dunia game:
- **Switch:** Dapat dimatikan/dinyalakan untuk mengontrol lampu
- **Collectible Items:** Objek yang bisa dipungut dan disimpan dalam inventori
- **Area Finish:** Area untuk berpindah antar level

**Implementasi:**
- Sistem raycasting dari kamera pemain untuk mendeteksi objek (`RayCast3D.gd`)
- Highlight visual pada objek yang bisa diinteraksikan
- Animasi untuk switch dalam kondisi on/off

### 4. Desain Level & Gameplay
Level 1 dirancang agar pemain harus mengumpulkan 4 item untuk membuka jalan keluar:

- **Item 1:** Terletak dekat rintangan yang jatuh ke lubang
- **Item 2:** Berada di ruang sempit yang memerlukan mekanik jongkok
- **Item 3:** Tersembunyi dalam struktur mini-maze untuk menguji navigasi
- **Item 4:** Ditempatkan di akhir rangkaian parkour sederhana

**Implementasi:**
- Logika penghitungan item dalam level_1.gd
- Fungsi `collect_item()` untuk melacak jumlah item yang dikumpulkan
- Fungsi `enable_finish()` yang mengaktifkan lampu dan trigger area keluar

## Alur Permainan

Pemain memulai di area pemilihan level di mana mereka dapat berinteraksi dengan kotak untuk memasuki Level 1. Di Level 1, mereka harus menjelajahi lingkungan untuk menemukan dan mengumpulkan 4 item tersembunyi, menghadapi tantangan berbeda untuk setiap item. Setelah pengumpulan, lampu keluar menyala dan menjadi aktif, memungkinkan melanjutkan ke layar kemenangan.

## Tantangan dalam Implementasi

Beberapa tantangan yang saya hadapi:
- Memastikan objek tetap fungsional saat digunakan dari inventory
- Implementasi deteksi langit-langit untuk mekanik jongkok
- Sinkronisasi UI inventori dengan status permainan

## Kesimpulan

Proyek ini menggabungkan berbagai elemen gameplay interaktif dalam lingkungan 3D pertama, dengan fokus pada eksplorasi, pengumpulan barang, dan pemecahan teka-teki sederhana melalui interaksi lingkungan.