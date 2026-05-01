import 'package:equatable/equatable.dart';

class HewanModel extends Equatable {
  final int id;
  final String nama;
  final String jenis;
  final String? tanggalLahir;
  final int harga;
  final String status;

  const HewanModel({
    required this.id,
    required this.nama,
    required this.jenis,
    this.tanggalLahir,
    required this.harga,
    required this.status,
  });

  factory HewanModel.fromJson(Map<String, dynamic> json) {
    return HewanModel(
      id: json["id"] as int,
      nama: json["nama"] as String? ?? '',
      jenis: json["jenis"] as String? ?? '',
      tanggalLahir: json["tanggal_lahir"] as String?,
      harga: json["harga"] as int? ?? 0,
      status: json["status"] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [id, nama, jenis, tanggalLahir, harga, status];
}