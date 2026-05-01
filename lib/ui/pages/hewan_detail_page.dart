import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/bloc/hewan/hewan_bloc.dart';
import '../../data/repositories/hewan_repository.dart';
import '../../data/models/hewan_model.dart';

class HewanDetailPage extends StatelessWidget {
  final int hewanId;
  final String hewanNama;

  const HewanDetailPage({
    super.key,
    required this.hewanId,
    required this.hewanNama,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HewanBloc(repository: HewanRepository())
        ..add(FetchHewanById(id: hewanId)),
      child: _HewanDetailView(hewanNama: hewanNama),
    );
  }
}

class _HewanDetailView extends StatelessWidget {
  final String hewanNama;

  const _HewanDetailView({required this.hewanNama});

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'sehat':
      case 'tersedia':
        return Colors.green.shade600;
      case 'sakit':
        return Colors.red.shade600;
      case 'dijual':
        return Colors.orange.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.green.shade600, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.green.shade600,
        elevation: 0,
        title: Text(
          hewanNama,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<HewanBloc, HewanState>(
        builder: (context, state) {
          if (state is HewanLoading) {
            return Center(
              child: CircularProgressIndicator(color: Colors.green.shade600),
            );
          }

          if (state is HewanError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red.shade400, size: 60),
                  const SizedBox(height: 12),
                  Text(
                    state.message,
                    style: TextStyle(color: Colors.grey.shade600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () => context
                        .read<HewanBloc>()
                        .add(FetchHewanById(id: context.read<HewanBloc>().state is HewanError ? 0 : 0)),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba Lagi'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is HewanDetailLoaded) {
            final hewan = state.hewan;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Hero Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green.shade600, Colors.green.shade400],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.pets, color: Colors.white, size: 36),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          hewan.nama,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          hewan.jenis,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.85),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            hewan.status,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Detail Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Informasi Detail',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Divider(),
                        _buildDetailRow('ID Hewan', '#${hewan.id}', Icons.tag),
                        _buildDetailRow('Nama', hewan.nama, Icons.pets),
                        _buildDetailRow('Jenis', hewan.jenis, Icons.category_outlined),
                        _buildDetailRow(
                          'Tanggal Lahir',
                          hewan.tanggalLahir ?? '-',
                          Icons.calendar_today_outlined,
                        ),
                        _buildDetailRow(
                          'Harga',
                          'Rp ${hewan.harga.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                          Icons.attach_money,
                        ),
                        _buildDetailRow('Status', hewan.status, Icons.info_outline),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
