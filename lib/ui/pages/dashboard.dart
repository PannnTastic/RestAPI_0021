import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/bloc/auth/auth_bloc.dart';
import '../../logic/bloc/hewan/hewan_bloc.dart';
import '../../data/models/hewan_model.dart';
import '../../data/repositories/hewan_repository.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HewanBloc(repository: HewanRepository())
        ..add(const FetchHewan()),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  void _showFormDialog(BuildContext context, {HewanModel? hewan}) {
    final namaController = TextEditingController(text: hewan?.nama ?? '');
    final jenisController = TextEditingController(text: hewan?.jenis ?? '');
    final tanggalController = TextEditingController(text: hewan?.tanggalLahir ?? '');
    final hargaController = TextEditingController(
      text: hewan?.harga != null ? hewan!.harga.toString() : '',
    );
    final statusController = TextEditingController(text: hewan?.status ?? '');

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          hewan == null ? 'Tambah Hewan' : 'Edit Hewan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogField(namaController, 'Nama', Icons.pets),
              const SizedBox(height: 12),
              _buildDialogField(jenisController, 'Jenis', Icons.category_outlined),
              const SizedBox(height: 12),
              _buildDialogField(tanggalController, 'Tanggal Lahir (YYYY-MM-DD)', Icons.calendar_today_outlined),
              const SizedBox(height: 12),
              _buildDialogField(hargaController, 'Harga', Icons.attach_money,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 12),
              _buildDialogField(statusController, 'Status', Icons.info_outline),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Batal', style: TextStyle(color: Colors.grey.shade600)),
          ),
          ElevatedButton(
            onPressed: () {
              final data = {
                'nama': namaController.text.trim(),
                'jenis': jenisController.text.trim(),
                'tanggalLahir': tanggalController.text.trim(),
                'harga': int.tryParse(hargaController.text.trim()) ?? 0,
                'status': statusController.text.trim(),
              };
              if (hewan == null) {
                context.read<HewanBloc>().add(CreateHewan(data: data));
              } else {
                context.read<HewanBloc>().add(UpdateHewan(id: hewan.id, data: data));
              }
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(hewan == null ? 'Tambah' : 'Simpan'),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20, color: Colors.green.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.green.shade600, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }

  void _confirmDelete(BuildContext context, HewanModel hewan) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Hapus Hewan?'),
        content: Text('Apakah Anda yakin ingin menghapus "${hewan.nama}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: TextStyle(color: Colors.grey.shade600)),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<HewanBloc>().add(DeleteHewan(id: hewan.id));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Hapus'),
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
        elevation: 0,
        backgroundColor: Colors.green.shade600,
        title: const Text(
          'Daftar Hewan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              context.read<AuthBloc>().add(const LogoutRequested());
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: BlocConsumer<HewanBloc, HewanState>(
        listener: (context, state) {
          if (state is HewanError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red.shade600,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
          if (state is HewanCreatedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Operasi berhasil!'),
                backgroundColor: Colors.green.shade600,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        },
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
                    'Gagal memuat data',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () =>
                        context.read<HewanBloc>().add(const FetchHewan()),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba Lagi'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is HewanLoaded) {
            if (state.hewanList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.pets, color: Colors.grey.shade300, size: 80),
                    const SizedBox(height: 12),
                    Text(
                      'Belum ada data hewan',
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async =>
                  context.read<HewanBloc>().add(const FetchHewan()),
              color: Colors.green.shade600,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.hewanList.length,
                itemBuilder: (context, index) {
                  final hewan = state.hewanList[index];
                  return _HewanCard(
                    hewan: hewan,
                    onEdit: () => _showFormDialog(context, hewan: hewan),
                    onDelete: () => _confirmDelete(context, hewan),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormDialog(context),
        backgroundColor: Colors.green.shade600,
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: 'Tambah Hewan',
      ),
    );
  }
}

class _HewanCard extends StatelessWidget {
  final HewanModel hewan;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _HewanCard({
    required this.hewan,
    required this.onEdit,
    required this.onDelete,
  });

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'sehat':
        return Colors.green.shade600;
      case 'sakit':
        return Colors.red.shade600;
      case 'dijual':
        return Colors.orange.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.pets, color: Colors.green.shade600, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hewan.nama,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hewan.jenis,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _statusColor(hewan.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          hewan.status,
                          style: TextStyle(
                            fontSize: 11,
                            color: _statusColor(hewan.status),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Rp ${hewan.harga.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  onPressed: onEdit,
                  icon: Icon(Icons.edit_outlined, color: Colors.blue.shade400, size: 22),
                  tooltip: 'Edit',
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: Icon(Icons.delete_outline, color: Colors.red.shade400, size: 22),
                  tooltip: 'Hapus',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
