import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/bloc/hewan/hewan_bloc.dart';
import '../../data/repositories/hewan_repository.dart';
import '../widgets/custom_widget.dart';

class AddHewanPage extends StatefulWidget {
  const AddHewanPage({super.key});

  @override
  State<AddHewanPage> createState() => _AddHewanPageState();
}

class _AddHewanPageState extends State<AddHewanPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _jenisController = TextEditingController();
  final _tanggalController = TextEditingController();
  final _hargaController = TextEditingController();
  final _statusController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _jenisController.dispose();
    _tanggalController.dispose();
    _hargaController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  void _onSave(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final data = {
        'nama': _namaController.text.trim(),
        'jenis': _jenisController.text.trim(),
        'tanggal_lahir': _tanggalController.text.trim().isEmpty
            ? null
            : _tanggalController.text.trim(),
        'harga': int.tryParse(_hargaController.text.trim()) ?? 0,
        'status': _statusController.text.trim(),
      };
      context.read<HewanBloc>().add(CreateHewan(data: data));
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(primary: Colors.green.shade600),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      _tanggalController.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HewanBloc(repository: HewanRepository()),
      child: Builder(
        builder: (context) => BlocListener<HewanBloc, HewanState>(
          listener: (context, state) {
            if (state is HewanCreatedSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Hewan berhasil ditambahkan!'),
                  backgroundColor: Colors.green.shade600,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
              Navigator.pop(context, true);
            }
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
          },
          child: Scaffold(
            backgroundColor: Colors.grey.shade50,
            appBar: AppBar(
              backgroundColor: Colors.green.shade600,
              elevation: 0,
              title: const Text(
                'Tambah Hewan',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: BlocBuilder<HewanBloc, HewanState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        _SectionHeader(title: 'Informasi Hewan'),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _namaController,
                          label: 'Nama Hewan',
                          prefixIcon: Icons.pets,
                          validator: (v) => v == null || v.isEmpty
                              ? 'Nama tidak boleh kosong'
                              : null,
                        ),
                        const SizedBox(height: 14),
                        CustomTextField(
                          controller: _jenisController,
                          label: 'Jenis Hewan',
                          prefixIcon: Icons.category_outlined,
                          validator: (v) => v == null || v.isEmpty
                              ? 'Jenis tidak boleh kosong'
                              : null,
                        ),
                        const SizedBox(height: 14),
                        // Tanggal Lahir dengan Date Picker
                        CustomTextField(
                          controller: _tanggalController,
                          label: 'Tanggal Lahir',
                          prefixIcon: Icons.calendar_today_outlined,
                          hintText: 'Pilih tanggal lahir (opsional)',
                          readOnly: true,
                          onTap: _pickDate,
                        ),
                        const SizedBox(height: 14),
                        CustomTextField(
                          controller: _hargaController,
                          label: 'Harga',
                          prefixIcon: Icons.attach_money,
                          hintText: 'Contoh: 5000000',
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Harga tidak boleh kosong';
                            }
                            if (int.tryParse(v) == null) {
                              return 'Harga harus berupa angka';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        _StatusDropdown(controller: _statusController),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: state is HewanLoading
                                ? null
                                : () => _onSave(context),
                            icon: state is HewanLoading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.save_outlined),
                            label: Text(
                              state is HewanLoading ? 'Menyimpan...' : 'Simpan',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade600,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                              shadowColor: Colors.green.withOpacity(0.4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade700,
      ),
    );
  }
}

class _StatusDropdown extends StatefulWidget {
  final TextEditingController controller;
  const _StatusDropdown({required this.controller});

  @override
  State<_StatusDropdown> createState() => _StatusDropdownState();
}

class _StatusDropdownState extends State<_StatusDropdown> {
  final List<String> _statusOptions = ['tersedia', 'terjual'];
  String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.controller.text.isEmpty ? null : widget.controller.text;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: _selected,
        decoration: InputDecoration(
          labelText: 'Status',
          labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          border: InputBorder.none,
          prefixIcon: Icon(Icons.info_outline, color: Colors.grey.shade400, size: 22),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        ),
        items: _statusOptions.map((s) => DropdownMenuItem(
          value: s,
          child: Text(s, style: const TextStyle(fontSize: 14)),
        )).toList(),
        onChanged: (val) {
          setState(() => _selected = val);
          widget.controller.text = val ?? '';
        },
        validator: (v) => v == null ? 'Status tidak boleh kosong' : null,
      ),
    );
  }
}
