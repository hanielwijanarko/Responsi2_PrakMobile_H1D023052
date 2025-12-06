import 'package:flutter/material.dart';
import '../services/inventaris_service.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final namaC = TextEditingController();
  final hargaC = TextEditingController();
  final jumlahC = TextEditingController();
  final tanggalC = TextEditingController();

  bool loading = false;

  void _showSnackBar(String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
        ),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

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

  addInventaris() async {
    if (namaC.text.isEmpty || hargaC.text.isEmpty || jumlahC.text.isEmpty || tanggalC.text.isEmpty) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          "Tambah Inventaris",
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              TextField(
                controller: namaC,
                decoration: InputDecoration(
                  labelText: "Nama Inventaris",
                  prefixIcon: const Icon(Icons.computer),
                  hintText: "Contoh: Monitor, Keyboard, dll",
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: hargaC,
                decoration: InputDecoration(
                  labelText: "Harga",
                  prefixIcon: const Icon(Icons.attach_money),
                  hintText: "Contoh: 500000",
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: jumlahC,
                decoration: InputDecoration(
                  labelText: "Jumlah",
                  prefixIcon: const Icon(Icons.numbers),
                  hintText: "Contoh: 10",
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: tanggalC,
                decoration: InputDecoration(
                  labelText: "Tanggal Masuk",
                  prefixIcon: const Icon(Icons.calendar_today),
                  hintText: "Pilih tanggal",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_month),
                    onPressed: _selectDate,
                  ),
                ),
                readOnly: true,
                onTap: _selectDate,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: loading ? null : addInventaris,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                            strokeWidth: 2,
                          ),
                        )
                      : const Text("Simpan Inventaris"),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF7F8C8D),
                  side: const BorderSide(color: Color(0xFFE0E0E0)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  "Batal",
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    namaC.dispose();
    hargaC.dispose();
    jumlahC.dispose();
    tanggalC.dispose();
    super.dispose();
  }
}
