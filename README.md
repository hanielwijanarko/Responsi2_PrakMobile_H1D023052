# Aplikasi Inventaris Komputer Haniel

Aplikasi mobile untuk manajemen inventaris komputer yang dibangun menggunakan Flutter dan backend Node.js/Express.

## 📋 Informasi Identitas

| Item | Deskripsi |
|------|-----------|
| **Nama** | [Haniel Wijanarko] |
| **NIM** | [H1D023052] |
| **Shift Asal** | [F] |
| **Shift Baru** | [E] |

## 🎥 Video Demo

Link video demo aplikasi: [hasil demo]

## 📱 Fitur Aplikasi

### 1. **Autentikasi (Login & Register)**
- Registrasi pengguna baru dengan validasi input
- Login dengan email dan password
- Session management
- Logout dengan konfirmasi

### 2. **Manajemen Inventaris (CRUD)**
- **Create** - Tambah inventaris baru
- **Read** - Melihat daftar semua inventaris
- **Update** - Edit data inventaris
- **Delete** - Hapus inventaris dengan konfirmasi
- Formatting currency (Rp format)
- Date picker untuk tanggal masuk

### 3. **UI/UX Modern**
- Design profesional dengan Poppins font
- Warna tema: Biru (#3498DB) & Abu-abu (#2C3E50)
- Responsive layout
- SnackBar notifications
- Dialog confirmations
- Loading indicators

---

## 🔌 Spesifikasi API

### Base URL
```
http://localhost:3000
```

### 1. Authentication Endpoints

#### Register User
```http
POST /auth/register
Content-Type: application/json

{
  "nama": "string",
  "email": "string",
  "password": "string"
}
```

**Response (201/200):**
```json
{
  "message": "User registered successfully",
  "user": {
    "id": "number",
    "nama": "string",
    "email": "string"
  }
}
```

**Response (400):**
```json
{
  "message": "Email already exists" atau "Invalid input"
}
```

---

#### Login
```http
POST /auth/login
Content-Type: application/json

{
  "email": "string",
  "password": "string"
}
```

**Response (200):**
```json
{
  "token": "jwt_token_string",
  "message": "Login successful"
}
```

**Response (401):**
```json
{
  "message": "Invalid email or password"
}
```

---

### 2. Inventaris Endpoints

#### Get All Inventaris
```http
GET /inventaris
```

**Response (200):**
```json
[
  {
    "id": 1,
    "nama": "Monitor LG 24 inch",
    "harga": 1500000,
    "jumlah": 5,
    "tanggal_masuk": "2024-12-01"
  },
  {
    "id": 2,
    "nama": "Keyboard Mechanical",
    "harga": 500000,
    "jumlah": 10,
    "tanggal_masuk": "2024-11-15"
  }
]
```

---

#### Create Inventaris
```http
POST /inventaris
Content-Type: application/json

{
  "nama": "string",
  "harga": "number",
  "jumlah": "number",
  "tanggal_masuk": "YYYY-MM-DD"
}
```

**Response (201/200):**
```json
{
  "message": "Inventaris created successfully",
  "id": "number",
  "nama": "string",
  "harga": "number",
  "jumlah": "number",
  "tanggal_masuk": "string"
}
```

---

#### Update Inventaris
```http
PUT /inventaris/:id
Content-Type: application/json

{
  "nama": "string",
  "harga": "number",
  "jumlah": "number",
  "tanggal_masuk": "YYYY-MM-DD"
}
```

**Response (200):**
```json
{
  "message": "Inventaris updated successfully",
  "id": "number",
  "nama": "string",
  "harga": "number",
  "jumlah": "number",
  "tanggal_masuk": "string"
}
```

---

#### Delete Inventaris
```http
DELETE /inventaris/:id
```

**Response (200):**
```json
{
  "message": "Inventaris deleted successfully"
}
```

**Response (404):**
```json
{
  "message": "Inventaris not found"
}
```

---

## 💻 Penjelasan Kode - Services

### AuthService (`lib/services/auth_service.dart`)

```dart
/// Fungsi untuk registrasi user baru
/// 
/// Parameters:
///   - nama: Nama lengkap user
///   - email: Email untuk login
///   - password: Password user
/// 
/// Returns:
///   - Map dengan struktur:
///     {
///       "success": bool,
///       "message": String error/success message
///     }
/// 
/// Error Handling:
///   - Network timeout 10 detik
///   - JSON parse error
///   - Server response error (status code bukan 200/201)
static Future<Map<String, dynamic>> register(String nama, String email, String password) async {
  try {
    final res = await http.post(
      Uri.parse("$baseUrl/auth/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nama": nama,
        "email": email,
        "password": password
      }),
    ).timeout(const Duration(seconds: 10));
    // ... implementation
  } catch (e) {
    return {"success": false, "message": "Error: $e"};
  }
}
```

**Penjelasan:**
- Mengirim POST request ke endpoint `/auth/register`
- Headers Content-Type diatur ke JSON
- Body berisi data user dalam format JSON
- Timeout 10 detik untuk mencegah request hanging
- Return Map berisi status success dan pesan

---

```dart
/// Fungsi untuk login
/// 
/// Parameters:
///   - email: Email user
///   - password: Password user
/// 
/// Returns:
///   - Map dengan struktur:
///     {
///       "success": bool,
///       "token": String (jika login berhasil),
///       "message": String
///     }
/// 
/// Usage:
///   final result = await AuthService.login("user@mail.com", "password123");
///   if (result["success"]) {
///     String token = result["token"];
///   }
static Future<Map<String, dynamic>> login(String email, String password) async {
  // ... implementation
}
```

**Penjelasan:**
- Mengirim POST request ke `/auth/login`
- Jika sukses (status 200), extract token dari response
- Token digunakan untuk autentikasi request ke endpoint lain
- Error handling untuk network dan server errors

---

### InventarisService (`lib/services/inventaris_service.dart`)

```dart
/// Fungsi untuk mendapatkan semua data inventaris dari API
/// 
/// Returns:
///   - Map dengan struktur:
///     {
///       "success": bool,
///       "data": List<Inventaris> (list inventaris atau kosong jika error)
///     }
/// 
/// Error Handling:
///   - Try-catch untuk network errors
///   - Timeout 10 detik
///   - JSON parsing error handling
/// 
/// Usage:
///   final result = await InventarisService.getAll();
///   if (result["success"]) {
///     List<Inventaris> inventaris = result["data"];
///   }
static Future<Map<String, dynamic>> getAll() async {
  try {
    final res = await http.get(Uri.parse("$baseUrl/inventaris"))
      .timeout(const Duration(seconds: 10));
    
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      final items = data.map((e) => Inventaris.fromJson(e)).toList();
      return {"success": true, "data": items};
    }
    return {"success": false, "data": []};
  } catch (e) {
    return {"success": false, "data": [], "error": e.toString()};
  }
}
```

**Penjelasan:**
- GET request ke `/inventaris` untuk mengambil semua data
- Response adalah array JSON yang di-parse menjadi List<Inventaris>
- Setiap object JSON di-convert ke model Inventaris menggunakan factory `fromJson`
- Error handling mencakup network errors dan parsing errors

---

```dart
/// Fungsi untuk membuat inventaris baru
/// 
/// Parameters:
///   - nama: Nama barang
///   - harga: Harga barang (integer)
///   - jumlah: Jumlah stok (integer)
///   - tanggal: Tanggal masuk (format: YYYY-MM-DD)
/// 
/// Returns:
///   - Map dengan struktur:
///     {
///       "success": bool,
///       "message": String (success/error message)
///     }
/// 
/// Usage:
///   final result = await InventarisService.create(
///     "Monitor LG 24",
///     1500000,
///     5,
///     "2024-12-01"
///   );
static Future<Map<String, dynamic>> create(String nama, int harga, int jumlah, String tanggal) async {
  // ... implementation
}
```

**Penjelasan:**
- POST request ke `/inventaris` dengan body JSON
- Integer parameters (harga, jumlah) langsung di-encode sebagai number
- Status code 200 atau 201 dianggap sukses
- Error message ditampilkan ke user via SnackBar

---

```dart
/// Fungsi untuk update inventaris
/// 
/// Parameters:
///   - id: ID inventaris yang akan diupdate
///   - nama: Nama barang (baru)
///   - harga: Harga barang (baru)
///   - jumlah: Jumlah stok (baru)
///   - tanggal: Tanggal masuk (baru)
/// 
/// Returns:
///   - Map dengan struktur:
///     {
///       "success": bool,
///       "message": String
///     }
/// 
/// HTTP Method: PUT /inventaris/:id
static Future<Map<String, dynamic>> update(int id, String nama, int harga, int jumlah, String tanggal) async {
  // ... implementation
}
```

**Penjelasan:**
- PUT request ke `/inventaris/{id}` dengan semua field yang diupdate
- ID path parameter di-embed di URL
- Seluruh object inventaris di-update (tidak partial)
- Return success/failure message

---

```dart
/// Fungsi untuk menghapus inventaris
/// 
/// Parameters:
///   - id: ID inventaris yang akan dihapus
/// 
/// Returns:
///   - Map dengan struktur:
///     {
///       "success": bool,
///       "message": String
///     }
/// 
/// HTTP Method: DELETE /inventaris/:id
/// 
/// Usage:
///   final result = await InventarisService.deleteItem(1);
///   if (result["success"]) {
///     print("Inventaris berhasil dihapus");
///   }
static Future<Map<String, dynamic>> deleteItem(int id) async {
  // ... implementation
}
```

**Penjelasan:**
- DELETE request ke `/inventaris/{id}`
- Tidak memerlukan request body
- Status code 200 menandakan sukses
- Server akan return 404 jika ID tidak ditemukan

---

## 💻 Penjelasan Kode - Models

### Inventaris Model (`lib/models/inventaris.dart`)

```dart
/// Model data untuk Inventaris
/// 
/// Properties:
///   - id: Unique identifier (primary key dari database)
///   - nama: Nama barang inventaris
///   - harga: Harga dalam Rupiah (integer)
///   - jumlah: Jumlah stok barang (integer)
///   - tanggalMasuk: Tanggal masuk inventaris (YYYY-MM-DD format)
class Inventaris {
  final int id;
  final String nama;
  final int harga;
  final int jumlah;
  final String tanggalMasuk;

  Inventaris({
    required this.id,
    required this.nama,
    required this.harga,
    required this.jumlah,
    required this.tanggalMasuk,
  });

  /// Factory constructor untuk membuat instance dari JSON
  /// 
  /// Mengkonversi JSON response dari API ke object Inventaris
  /// 
  /// Mapping JSON ke Properties:
  ///   - json['id'] → id
  ///   - json['nama'] → nama
  ///   - json['harga'] → harga
  ///   - json['jumlah'] → jumlah
  ///   - json['tanggal_masuk'] → tanggalMasuk (snake_case ke camelCase)
  /// 
  /// Usage:
  ///   Map<String, dynamic> jsonData = {"id": 1, "nama": "Monitor", ...};
  ///   Inventaris inv = Inventaris.fromJson(jsonData);
  factory Inventaris.fromJson(Map<String, dynamic> json) {
    return Inventaris(
      id: json['id'],
      nama: json['nama'],
      harga: json['harga'],
      jumlah: json['jumlah'],
      tanggalMasuk: json['tanggal_masuk'],
    );
  }
}
```

**Penjelasan:**
- Model data adalah class yang merepresentasikan struktur data inventaris
- `required` parameters memastikan semua field harus diisi saat inisialisasi
- Factory `fromJson` adalah design pattern untuk deserialize JSON → Object
- Mapping `tanggal_masuk` → `tanggalMasuk` mengikuti convention Dart (camelCase)

---

## 🛠️ Teknologi yang Digunakan

### Frontend (Mobile)
- **Framework**: Flutter
- **Language**: Dart
- **HTTP Client**: `http` package ^1.1.0
- **UI Components**: Material Design 3

### Backend
- **Runtime**: Node.js
- **Framework**: Express.js
- **Port**: 3000

### Design & Styling
- **Font**: Poppins (Google Fonts)
- **Color Scheme**:
  - Primary: #2C3E50 (Dark Blue-Gray)
  - Accent: #3498DB (Sky Blue)
  - Background: #F5F7FA (Light Gray)
  - Text Secondary: #7F8C8D (Gray)

---

## 📦 Project Structure

```
lib/
├── main.dart                 # Entry point & Theme configuration
├── models/
│   └── inventaris.dart      # Inventaris data model dengan fromJson
├── services/
│   ├── auth_service.dart    # Authentication API calls
│   └── inventaris_service.dart # Inventaris CRUD API calls
└── pages/
    ├── login_page.dart      # Login UI & logic
    ├── register_page.dart   # Register UI & logic
    ├── home_page.dart       # List inventaris & main app
    ├── add_page.dart        # Add inventaris form
    └── edit_page.dart       # Edit inventaris form
```

---

## 🚀 Cara Menjalankan Aplikasi

### Prerequisites
- Flutter SDK v3.9.2+
- Node.js v14+
- Android emulator atau iOS simulator
- Backend API sudah berjalan

### Langkah-langkah

1. **Clone/Setup Project**
   ```bash
   cd responsi_2_mobile_paket_1_h1d023052
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Jalankan Backend API**
   ```bash
   npm start
   ```
   (Pastikan API running di `http://localhost:3000`)

4. **Jalankan Flutter App**
   ```bash
   flutter run
   ```

5. **Test Aplikasi**
   - Register akun baru
   - Login
   - Tambah inventaris
   - Edit inventaris
   - Hapus inventaris
   - Logout

---

## 📝 Catatan Penting

- Pastikan API server sudah berjalan sebelum menjalankan aplikasi
- Gunakan emulator Android atau iOS simulator untuk testing
- Network request memiliki timeout 10 detik
- Error handling sudah diterapkan di semua API calls
- Semua input di-validate sebelum dikirim ke server

---

## 👨‍💻 Dibuat oleh

[Haniel Wijanarko] - [Shift F]

