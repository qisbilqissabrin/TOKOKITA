## Penjelasan Kode

### 1. `main.dart`

* **Fungsi:** Menjalankan widget root (`MyApp`) dan menentukan halaman awal yang akan dimuat.
* **Implementasi:**
    * Mengimpor `material.dart` dan halaman awal yang dituju (`login_page.dart` atau `produk_page.dart` tergantung konfigurasi akhir).
    * `main()`: Memanggil `runApp(const MyApp())`.
    * `MyApp`: Mengembalikan `MaterialApp` dengan judul 'Toko Kita' dan menunjuk ke halaman awal (misalnya, `LoginPage()` atau `ProdukPage()`).

---

### 2. `ui/login_page.dart`
<img width="782" height="888" alt="Screenshot 2025-11-25 191801" src="https://github.com/user-attachments/assets/dc6a204b-2d5a-4e64-947b-cbef11679ca8" />
Halaman ini berfungsi untuk otentikasi pengguna.

* **Tujuan:** Meminta input **Email** dan **Password**, serta menyediakan navigasi ke halaman Registrasi.
* **Komponen Kunci:**
    * `GlobalKey<FormState>`: Digunakan untuk memvalidasi semua input *field* secara kolektif saat tombol Login ditekan.
    * `TextEditingController`: Digunakan untuk mengambil nilai teks dari *Text Form Field* Email dan Password.
    * `_emailTextField()` & `_passwordTextField()`: Widget yang mengimplementasikan `TextFormField` lengkap dengan properti `validator` untuk memastikan input tidak kosong dan memenuhi kriteria (misalnya, panjang minimal password).
    * `_buttonLogin()`: Tombol yang memicu validasi form melalui `_formKey.currentState.validate()`.
    * `_menuRegistrasi()`: Menggunakan `InkWell` untuk melakukan navigasi (`Navigator.push`) ke `RegistrasiPage`.

---

### 3. `ui/registrasi_page.dart`
<img width="774" height="892" alt="Screenshot 2025-11-25 191841" src="https://github.com/user-attachments/assets/fa9485f1-c1ce-45fe-8fe0-1e997ff310e1" />
Halaman ini menangani pendaftaran pengguna baru.

* **Tujuan:** Mengambil input data lengkap untuk membuat akun baru.
* **Komponen Kunci:**
    * Sama seperti Login, menggunakan `GlobalKey<FormState>` dan `TextEditingController` untuk Nama, Email, dan Password.
    * **Validasi Kompleks:** Menerapkan validasi:
        * **Nama:** Minimal 3 karakter.
        * **Email:** Harus diisi dan memiliki format *regex* yang valid.
        * **Password:** Minimal 6 karakter.
        * **Konfirmasi Password:** Membandingkan nilai input dengan nilai di `_passwordTextController.text` untuk memastikan keduanya sama.
    * `_buttonRegistrasi()`: Memicu proses validasi form sebelum data dikirim ke server.

---

### 4. `model/login.dart` & `model/registrasi.dart`

* **Tujuan:** Digunakan untuk memetakan (deserialisasi) respons data yang diterima dari API dalam format JSON ke dalam objek Dart yang terstruktur.
* **Implementasi:**
    * Memiliki properti seperti `code`, `status`, `token`, `userID`, dll.
    * **`factory ClassName.fromJson(Map<String, dynamic> obj)`:** *Factory constructor* standar yang bertanggung jawab untuk mengambil data dari map JSON (`obj`) dan mengisi properti objek model. Logika pada `Login.fromJson` juga menyertakan *conditional check* (`if (obj['code'] == 200)`) untuk menangani respons Sukses (dengan data terstruktur) dan Gagal (dengan data kosong/error).

---

### 5. `model/produk.dart`

Kelas model khusus untuk data produk.

* **Tujuan:** Merepresentasikan data produk dengan properti seperti `id`, `kodeProduk`, `namaProduk`, dan `hargaProduk`.
* **Implementasi:** Menyediakan *constructor* utama dan *factory constructor* `Produk.fromJson` untuk deserialisasi data produk dari API.

---

### 6. `ui/produk_page.dart`
Halaman utama yang menampilkan daftar semua produk.

* **Tujuan:** Menampilkan *list* produk dan menyediakan navigasi serta opsi *logout*.
* **Komponen Kunci:**
    * **`AppBar Actions`**: Menyediakan ikon **Tambah (`Icons.add`)** yang, ketika diketuk (`onTap`), menavigasi ke `ProdukForm` untuk menambahkan produk baru.
    * **`Drawer`**: Menu samping yang berisi opsi `Logout`.
    * **`ListView`**: Digunakan untuk menampilkan item-item produk, yang setiap itemnya diwakili oleh widget `ItemProduk`.
    * **`ItemProduk` (StatelessWidget)**: Widget terpisah yang menerima objek `Produk` dan menampilkannya dalam `Card` atau `ListTile`. `GestureDetector` pada item ini memungkinkan navigasi ke `ProdukDetail` saat diketuk, sambil mengirimkan objek produk terkait.

---

### 7. `ui/produk_detail.dart`
<img width="778" height="904" alt="Screenshot 2025-11-25 191519" src="https://github.com/user-attachments/assets/6f709e89-6c4a-44e3-bba7-13d537a1d8d3" />
Halaman untuk melihat detail lengkap satu produk dan mengelola operasinya (Edit/Delete).

* **Tujuan:** Menampilkan data spesifik produk yang dipilih.
* **Komponen Kunci:**
    * Menerima objek `Produk` melalui `widget.produk!`.
    * Menampilkan detail (`kodeProduk`, `namaProduk`, `hargaProduk`) menggunakan widget `Text`.
    * `_tombolHapusEdit()`: Berisi `Row` dengan dua tombol:
        * **EDIT**: Navigasi ke `ProdukForm` sambil **mengirimkan objek produk** (`ProdukForm(produk: widget.produk!)`) untuk mengaktifkan mode Update.
        * **DELETE**: Memanggil `confirmHapus()` untuk menampilkan `AlertDialog`.
    * `confirmHapus()`: Menampilkan dialog konfirmasi. Jika "Ya" ditekan, ia akan memicu fungsi penghapusan data (asumsi memanggil *bloc* atau *service* tertentu) dan kemudian menavigasi kembali ke `ProdukPage`.

---

### 8. `ui/produk_form.dart`
<img width="775" height="901" alt="Screenshot 2025-11-25 191554" src="https://github.com/user-attachments/assets/298bddbc-c105-4735-ab3c-1807d6c683ae" />
Halaman form yang digunakan untuk membuat produk baru atau mengedit produk yang sudah ada.

* **Tujuan:** Menangani proses *Create* (Tambah) dan *Update* (Ubah) data produk.
* **Komponen Kunci:**
    * Menerima `Produk? produk` (nullable).
    * `initState()` & `isUpdate()`: Logika untuk menentukan apakah form berada dalam mode **TAMBAH** atau **UBAH**. Jika `widget.produk` tidak `null`, maka mode *Update* diaktifkan, dan data produk dimuat ke dalam *Text Controller*.
    * `_kodeProdukTextField()`, `_namaProdukTextField()`, `_hargaProdukTextField()`: *Text Form Field* standar dengan validasi wajib diisi.
    * `_buttonSubmit()`: Tombol yang teksnya berubah menjadi "SIMPAN" atau "UBAH" berdasarkan mode yang aktif. Setelah validasi berhasil, tombol ini memicu proses pengiriman data ke API.
