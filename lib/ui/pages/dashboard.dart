import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/bloc/auth/auth_bloc.dart';
import '../../logic/bloc/hewan/hewan_bloc.dart';
import '../../data/models/hewan_model.dart';
import '../../data/repositories/hewan_repository.dart';
import 'hewan_detail_page.dart';
import 'add_hewan_page.dart';
import 'edit_hewan_page.dart';

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

  // ── Konfirmasi Logout ─────────────────────────────────────
  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.logout, color: Colors.red.shade500, size: 24),
            const SizedBox(width: 8),
            const Text(
              'Keluar Akun',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari akun ini?',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: TextStyle(color: Colors.grey.shade600)),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(const LogoutRequested());
            },
            icon: const Icon(Icons.logout, size: 18),
            label: const Text('Keluar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Navigasi ke Add Hewan ─────────────────────────────────
  Future<void> _goToAdd(BuildContext context) async {
    final bloc = context.read<HewanBloc>();
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const AddHewanPage()),
    );
    if (result == true) {
      bloc.add(const FetchHewan());
    }
  }

  // ── Navigasi ke Edit Hewan ────────────────────────────────
  Future<void> _goToEdit(BuildContext context, HewanModel hewan) async {
    final bloc = context.read<HewanBloc>();
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => EditHewanPage(hewan: hewan)),
    );
    if (result == true) {
      bloc.add(const FetchHewan());
    }
  }

  // ── Konfirmasi Delete ─────────────────────────────────────
  void _confirmDelete(BuildContext context, HewanModel hewan) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.delete_outline, color: Colors.red.shade500, size: 24),
            const SizedBox(width: 8),
            const Text(
              'Hapus Hewan?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text('Apakah Anda yakin ingin menghapus "${hewan.nama}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: TextStyle(color: Colors.grey.shade600)),
          ),
          ElevatedButton.icon(
            onPressed: () {
              context.read<HewanBloc>().add(DeleteHewan(id: hewan.id));
              Navigator.pop(context);
            },
            icon: const Icon(Icons.delete_outline, size: 18),
            label: const Text('Hapus'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
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
        elevation: 0,
        backgroundColor: Colors.green.shade600,
        title: const Text(
          'Daftar Hewan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => _confirmLogout(context),
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
                    borderRadius: BorderRadius.circular(10)),
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
                    borderRadius: BorderRadius.circular(10)),
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
                  Icon(Icons.error_outline,
                      color: Colors.red.shade400, size: 60),
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
                          borderRadius: BorderRadius.circular(12)),
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
                      style: TextStyle(
                          color: Colors.grey.shade500, fontSize: 16),
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
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HewanDetailPage(
                          hewanId: hewan.id,
                          hewanNama: hewan.nama,
                        ),
                      ),
                    ),
                    onEdit: () => _goToEdit(context, hewan),
                    onDelete: () => _confirmDelete(context, hewan),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _goToAdd(context),
        backgroundColor: Colors.green.shade600,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Tambah Hewan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        tooltip: 'Tambah Hewan',
      ),
    );
  }
}

// ── Card Widget ───────────────────────────────────────────────
class _HewanCard extends StatelessWidget {
  final HewanModel hewan;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _HewanCard({
    required this.hewan,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'sehat':
      case 'tersedia':
        return Colors.green.shade600;
      case 'sakit':
        return Colors.red.shade600;
      case 'terjual':
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
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
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
                child:
                    Icon(Icons.pets, color: Colors.green.shade600, size: 26),
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
                      style: TextStyle(
                          fontSize: 13, color: Colors.grey.shade500),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
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
                    icon: Icon(Icons.edit_outlined,
                        color: Colors.blue.shade400, size: 22),
                    tooltip: 'Edit',
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: Icon(Icons.delete_outline,
                        color: Colors.red.shade400, size: 22),
                    tooltip: 'Hapus',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
