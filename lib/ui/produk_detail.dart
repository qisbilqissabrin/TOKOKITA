import 'package:flutter/material.dart';
import 'package:tokokita/bloc/produk_bloc.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/produk_form.dart';
import 'package:tokokita/ui/produk_page.dart';
import 'package:tokokita/widget/success_dialog.dart';
import 'package:tokokita/widget/warning_dialog.dart';

// ignore: must_be_immutable
class ProdukDetail extends StatefulWidget {
  Produk? produk;

  ProdukDetail({Key? key, this.produk}) : super(key: key);

  @override
  _ProdukDetailState createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              "Kode : ${widget.produk!.kodeProduk}",
              style: const TextStyle(fontSize: 20.0),
            ),
            Text(
              "Nama : ${widget.produk!.namaProduk}",
              style: const TextStyle(fontSize: 18.0),
            ),
            Text(
              "Harga : Rp. ${widget.produk!.hargaProduk.toString()}",
              style: const TextStyle(fontSize: 18.0),
            ),
            _tombolHapusEdit(),
          ],
        ),
      ),
    );
  }

  Widget _tombolHapusEdit() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton(
          child: const Text("EDIT"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProdukForm(
                  produk: widget.produk,
                ),
              ),
            );
          },
        ),
        OutlinedButton(
          child: const Text("DELETE"),
          onPressed: () => confirmHapus(),
        ),
      ],
    );
  }

  void confirmHapus() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text("Yakin ingin menghapus data ini?"),
          actions: [
            OutlinedButton(
              child: const Text("Ya"),
              onPressed: () {
                // Tutup dialog konfirmasi sebelum memproses hapus
                Navigator.pop(context);

                ProdukBloc.deleteProduk(id: int.parse(widget.produk!.id!))
                    .then(
                  (value) {
                    // Check if deletion was successful (value should be true)
                    if (value == true) {
                      // Tampilkan success dialog sebelum navigasi
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => SuccessDialog(
                          description: "Produk berhasil dihapus",
                          okClick: () {
                            Navigator.pop(context); // Tutup success dialog
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const ProdukPage(),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      // Jika backend return false di field 'data'
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => const WarningDialog(
                          description: "Hapus gagal, silakan coba lagi",
                        ),
                      );
                    }
                  },
                ).onError((error, stackTrace) {
                  // Tampilkan dialog peringatan jika ada error/exception
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => const WarningDialog(
                      description: "Hapus gagal, silakan coba lagi",
                    ),
                  );
                });
              },
            ),
            OutlinedButton(
              child: const Text("Batal"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}