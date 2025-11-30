# TOKOKITA

## 1. Proses Otentikasi Pengguna

### a. Proses Registrasi

**Tujuan:** Membuat akun pengguna baru.

* **Langkah A: Input Data**
    Pengguna mengisi semua *field* (Nama, Email, Password, Konfirmasi Password) pada form Registrasi.
    
<img width="741" height="819" alt="Screenshot 2025-12-01 003016" src="https://github.com/user-attachments/assets/893ee45c-2554-4c0f-84f8-953858f33a84" />


* **Langkah B: Konfirmasi Sukses**
    Setelah menekan tombol Registrasi, sistem memberikan *popup* konfirmasi bahwa proses berhasil, mengarahkan pengguna ke halaman Login.
<img width="746" height="824" alt="Screenshot 2025-12-01 003731" src="https://github.com/user-attachments/assets/cbc11a91-2114-48aa-be16-187036de66f1" />


**Contoh Logika Kode:**
```java
if (password.equals(konfirmasiPassword)) {
    // Menyimpan data ke database
    databaseManager.saveUser(nama, email, password);
    showSuccessPopup("Registrasi berhasil, silakan login.");
}
````

2. Proses Login

**Tujuan:** Memverifikasi identitas pengguna untuk mengakses sistem.

  * **Langkah A: Input Kredensial**
    Pengguna memasukkan Email (`icis@gmail.com`) dan Password yang telah terdaftar pada halaman Login.
<img width="741" height="825" alt="Screenshot 2025-12-01 003808" src="https://github.com/user-attachments/assets/febe97b5-5653-4f09-9bcd-c6ca143cb9f7" />

  * **Langkah B: Navigasi ke List Produk**
    Verifikasi berhasil akan mengalihkan pengguna ke halaman **List Produk** (tampilan awal).
<img width="739" height="820" alt="Screenshot 2025-12-01 003822" src="https://github.com/user-attachments/assets/ca9727fb-3f7b-4e92-b905-fd21b2476f16" />

**Contoh Logika Kode:**

```java
if (databaseManager.verifyCredentials(email, password)) {
    // Login berhasil
    navigateToProductList();
} else {
    showErrorToast("Email atau Password salah.");
}
```

-----

## 3. Proses Manajemen Produk (CRUD)

Pengelolaan data produk dilakukan setelah pengguna berhasil Login.

### 3.1. Create (C): Tambah Data Produk

  * **Langkah A: Pengisian Form Tambah Produk**
    Pengguna mengisi form **TAMBAH PRODUK** dengan detail: Kode (`01`), Nama (`Penghapus`), dan Harga (`1000`).
<img width="738" height="818" alt="Screenshot 2025-12-01 003842" src="https://github.com/user-attachments/assets/8b3754fc-9a79-4e00-a434-b9a2780d3bc5" />


  * **Langkah B: Data Tampil di List**
    Produk baru yang disimpan akan langsung terlihat pada halaman **List Produk**.
<img width="741" height="824" alt="Screenshot 2025-12-01 003850" src="https://github.com/user-attachments/assets/ef0d7984-e472-48a3-b6c9-4176dfcfe769" />


**Contoh Logika Kode:**

```java
// Memanggil fungsi untuk menyimpan data produk
databaseManager.insertProduct(kode, nama, harga);
refreshProductList();
```

### a. Read (R): Melihat Detail Produk

  * **Akses Detail Produk**
    Halaman **Detail Produk** menampilkan informasi produk lengkap, termasuk opsi **EDIT** dan **DELETE**.
<img width="737" height="814" alt="Screenshot 2025-12-01 003900" src="https://github.com/user-attachments/assets/a48f949f-5eea-4572-8377-be9e3240605a" />

### b. Update (U): Mengubah Data Produk

  * **Langkah A: Modifikasi Data pada Form**
    Melalui tombol EDIT, pengguna mengakses form **UBAH PRODUK** dan memodifikasi nilai (Contoh: Harga diubah dari `1000` menjadi `2000`).
<img width="739" height="828" alt="Screenshot 2025-12-01 003916" src="https://github.com/user-attachments/assets/f3b1573b-b316-41d4-a5a9-c4d4040bf413" />


  * **Langkah B: Verifikasi Update di List**
    Perubahan diterapkan, dan **List Produk** menampilkan harga yang sudah diupdate.
<img width="751" height="829" alt="Screenshot 2025-12-01 003923" src="https://github.com/user-attachments/assets/04f05d4e-c52c-4b94-a1cc-3e6e9af97d24" />


**Contoh Logika Kode:**

```java
// Melakukan update data produk berdasarkan Kode Produk
databaseManager.updateProduct(kodeProduk, newName, newPrice);
refreshProductList();
```

###  c. Delete (D): Menghapus Data Produk

  * **Langkah A: Eksekusi Hapus**
    Dari halaman Detail Produk, menekan tombol **DELETE** akan memicu proses penghapusan data.
<img width="740" height="819" alt="Screenshot 2025-12-01 004011" src="https://github.com/user-attachments/assets/4242bafe-0e6f-45f1-be02-dfe49f9fb6ce" />

  * **Langkah B: List Kembali Kosong**
    Aplikasi kembali ke halaman **List Produk**, yang kini kembali kosong (jika produk yang dihapus adalah satu-satunya), memverifikasi bahwa data telah terhapus.
<img width="733" height="894" alt="Screenshot 2025-12-01 005115" src="https://github.com/user-attachments/assets/99b3abe6-5b39-4816-ad94-90d1260019be" />

**Contoh Logika Kode:**

```java
// Menghapus data berdasarkan ID/Kode produk
databaseManager.deleteProduct(productId);
navigateBackToProductList();
```
