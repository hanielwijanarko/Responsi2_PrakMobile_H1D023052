# Aplikasi Inventaris Komputer Alfaen

Aplikasi mobile untuk manajemen inventaris komputer yang dibangun menggunakan Flutter dan backend Node.js/Express.

## 📋 Informasi Identitas

| Item | Deskripsi |
|------|-----------|
| **Nama** | [Mukhammad Alfaen Fadillah] |
| **NIM** | [H1D023032] |
| **Shift Asal** | [B] |
| **Shift Baru** | [E] |

## 🎥 Video Demo

Link video demo aplikasi: [Masukkan link video demo Anda di sini]

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

## 💻 Penjelasan Kode - Pages

### LoginPage (`lib/pages/login_page.dart`)

```dart
/// Fungsi login yang dijalankan saat user tap tombol Login
/// 
/// Proses:
///   1. Validasi input (email & password tidak kosong)
///   2. Set loading state = true (untuk disable button & show loading)
///   3. Call AuthService.login()
///   4. Tunggu response dari API
///   5. Set loading state = false
///   6. Jika sukses: navigate ke HomePage
///   7. Jika gagal: tampilkan error SnackBar
/// 
/// Error Handling:
///   - Empty input validation
///   - Network error
///   - Invalid credentials
login() async {
  if (emailC.text.isEmpty || pwC.text.isEmpty) {
    _showSnackBar("Email dan password harus diisi");
    return;
  }

  setState(() => loading = true);
  final result = await AuthService.login(emailC.text, pwC.text);
  setState(() => loading = false);

  if (result["success"]) {
    _showSnackBar("Login berhasil", isSuccess: true);
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    });
  } else {
    _showSnackBar(result["message"]);
  }
}
```

**Penjelasan:**
- Validasi input pertama kali sebelum API call
- `setState()` digunakan untuk update UI (loading indicator)
- `await` menunggu response dari API (async operation)
- `Navigator.pushReplacement` navigasi ke HomePage dan hapus LoginPage dari stack
- Delay 500ms sebelum navigate untuk UX yang lebih baik

---

### HomePage (`lib/pages/home_page.dart`)

```dart
/// Fungsi untuk load/reload data inventaris dari API
/// 
/// Dijalankan pada:
///   - initState() - saat halaman pertama kali dibuat
///   - Setelah add/edit/delete inventaris
/// 
/// Proses:
///   1. Call InventarisService.getAll()
///   2. Update futureInventaris variable (trigger FutureBuilder rebuild)
///   3. FutureBuilder akan menampilkan data inventaris
void _loadInventaris() {
  futureInventaris = InventarisService.getAll();
}
```

**Penjelasan:**
- Method ini di-call multiple times untuk refresh data
- FutureBuilder widget akan otomatis rebuild ketika future berubah
- Ini adalah pattern untuk handle async data dalam Flutter

---

```dart
/// Fungsi untuk menampilkan dialog konfirmasi sebelum delete
/// 
/// Parameters:
///   - id: ID inventaris yang akan dihapus
///   - nama: Nama inventaris (untuk ditampilkan di dialog)
/// 
/// Proses:
///   1. Tampilkan AlertDialog dengan pertanyaan konfirmasi
///   2. User bisa pilih "Batal" atau "Hapus"
///   3. Jika Hapus: call deleteItem() dari InventarisService
///   4. Refresh data dan tampilkan success message
void _deleteConfirmation(int id, String nama) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text("Hapus Inventaris"),
      content: Text('Apakah Anda yakin ingin menghapus "$nama"?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Batal"),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            final result = await InventarisService.deleteItem(id);
            if (result["success"]) {
              _showSnackBar(result["message"], isSuccess: true);
              _loadInventaris();
              setState(() {});
            }
          },
          child: const Text("Hapus", style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}
```

**Penjelasan:**
- AlertDialog menampilkan pertanyaan konfirmasi sebelum delete
- Callback `onPressed` di tombol Hapus melakukan delete operation
- `Navigator.pop(context)` menutup dialog sebelum API call
- `_loadInventaris()` dan `setState(() {})` untuk refresh UI setelah delete

---

```dart
/// Fungsi untuk format angka menjadi format currency Rupiah
/// 
/// Parameters:
///   - value: Integer value yang akan diformat
/// 
/// Returns:
///   - String dengan format "Rp X.XXX.XXX"
/// 
/// Contoh:
///   _formatCurrency(1500000) → "Rp 1.500.000"
///   _formatCurrency(50000) → "Rp 50.000"
String _formatCurrency(int value) {
  return "Rp ${value.toString().replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'), 
    (Match m) => '${m[1]}.'
  )}";
}
```

**Penjelasan:**
- Menggunakan regex untuk menambahkan separator setiap 3 digit
- RegExp `r'(\d)(?=(\d{3})+(?!\d))'` adalah pattern untuk thousands separator
- `replaceAllMapped` mengganti setiap match dengan format yang ditambahkan dot

---

### AddPage (`lib/pages/add_page.dart`)

```dart
/// Fungsi untuk menambah inventaris baru
/// 
/// Validasi:
///   - Semua field harus diisi
/// 
/// Proses:
///   1. Validasi input
///   2. Set loading = true
///   3. Call InventarisService.create()
///   4. Jika sukses: return true ke HomePage untuk refresh
///   5. Jika gagal: tampilkan error message
addInventaris() async {
  if (namaC.text.isEmpty || hargaC.text.isEmpty || 
      jumlahC.text.isEmpty || tanggalC.text.isEmpty) {
    _showSnackBar("Semua field harus diisi");
    return;
  }

  setState(() => loading = true);
  final result = await InventarisService.create(
    namaC.text,
    int.parse(hargaC.text),
    int.parse(jumlahC.text),
    tanggalC.text,
  );
  setState(() => loading = false);

  if (result["success"]) {
    Navigator.pop(context, true);
  } else {
    _showSnackBar(result["message"]);
  }
}
```

**Penjelasan:**
- Input validation dilakukan sebelum API call
- `int.parse()` mengkonversi String dari TextField menjadi Integer
- `Navigator.pop(context, true)` menutup page dan return true sebagai signal sukses
- HomePage akan menerima return value dan melakukan refresh

---

```dart
/// Fungsi untuk membuka date picker calendar
/// 
/// Proses:
///   1. Tampilkan native date picker dialog
///   2. User pilih tanggal
///   3. Format tanggal ke "YYYY-MM-DD"
///   4. Set value ke TextEditingController tanggalC
/// 
/// Usage:
///   - User tap pada TextField atau tap icon calendar
Future<void> _selectDate() async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime.now(),
  );
  if (picked != null) {
    tanggalC.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
  }
}
```

**Penjelasan:**
- `showDatePicker()` adalah native Flutter widget untuk date selection
- `initialDate: DateTime.now()` set tanggal awal ke hari ini
- `lastDate: DateTime.now()` membatasi user hanya bisa pilih tanggal di masa lalu
- `padLeft(2, '0')` memastikan month dan day selalu 2 digit (01-12, 01-31)

---

### EditPage (`lib/pages/edit_page.dart`)

```dart
/// Fungsi untuk update inventaris
/// 
/// Perbedaan dengan AddPage:
///   - TextEditingController di-initialize dengan nilai lama (di initState)
///   - API endpoint adalah PUT bukan POST
///   - Pass widget.inventaris.id sebagai parameter
/// 
/// Proses:
///   1. Validasi input
///   2. Call InventarisService.update()
///   3. Jika sukses: return true ke HomePage
///   4. Jika gagal: tampilkan error
updateInventaris() async {
  if (namaC.text.isEmpty || hargaC.text.isEmpty || 
      jumlahC.text.isEmpty || tanggalC.text.isEmpty) {
    _showSnackBar("Semua field harus diisi");
    return;
  }

  setState(() => loading = true);
  final result = await InventarisService.update(
    widget.inventaris.id,
    namaC.text,
    int.parse(hargaC.text),
    int.parse(jumlahC.text),
    tanggalC.text,
  );
  setState(() => loading = false);

  if (result["success"]) {
    Navigator.pop(context, true);
  } else {
    _showSnackBar(result["message"]);
  }
}
```

**Penjelasan:**
- `widget.inventaris` adalah parameter yang diterima dari HomePage
- Pre-fill form dengan nilai lama memudahkan user untuk edit sebagian field
- Pass ID inventaris ke API agar tahu mana yang di-update

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
- **Database**: [Sesuai dengan backend Anda]
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
   cd responsi_2_mobile_paket_1_h1d023032
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

[Nama Anda] - [Shift Anda]

