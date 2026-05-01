import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/bloc/hewan/hewan_bloc.dart';
import '../../data/repositories/hewan_repository.dart';
import '../../data/models/hewan_model.dart';
import '../widgets/custom_widget.dart';

class EditHewanPage extends StatefulWidget {
  final HewanModel hewan;

  const EditHewanPage({super.key, required this.hewan});

  @override
  State<EditHewanPage> createState() => _EditHewanPageState();
}

class _EditHewanPageState extends State<EditHewanPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _namaController;
  late final TextEditingController _jenisController;
  late final TextEditingController _tanggalController;
  late final TextEditingController _hargaController;
  late final TextEditingController _statusController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.hewan.nama);
    _jenisController = TextEditingController(text: widget.hewan.jenis);
    _tanggalController =
        TextEditingController(text: widget.hewan.tanggalLahir ?? '');
    _hargaController =
        TextEditingController(text: widget.hewan.harga.toString());
    _statusController = TextEditingController(text: widget.hewan.status);
  }

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
      context
          .read<HewanBloc>()
          .add(UpdateHewan(id: widget.hewan.id, data: data));
    }
  }

  Future<void> _pickDate() async {
    DateTime initial = DateTime.now();
    if (widget.hewan.tanggalLahir != null) {
      try {
        initial = DateTime.parse(widget.hewan.tanggalLahir!);
      } catch (_) {}
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
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
                  content: const Text('Hewan berhasil diupdate!'),
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
              title: Text(
                'Edit: ${widget.hewan.nama}',
                style: const TextStyle(
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
                        // Info badge
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline,
                                  color: Colors.blue.shade600, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'Editing ID #${widget.hewan.id}',
                                style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Informasi Hewan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                        ),
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
                              state is HewanLoading
                                  ? 'Menyimpan...'
                                  : 'Simpan Perubahan',
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
    final val = widget.controller.text;
    _selected = _statusOptions.contains(val) ? val : null;
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
          prefixIcon:
              Icon(Icons.info_outline, color: Colors.grey.shade400, size: 22),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        ),
        items: _statusOptions
            .map((s) => DropdownMenuItem(
                  value: s,
                  child: Text(s, style: const TextStyle(fontSize: 14)),
                ))
            .toList(),
        onChanged: (val) {
          setState(() => _selected = val);
          widget.controller.text = val ?? '';
        },
        validator: (v) => v == null ? 'Status tidak boleh kosong' : null,
      ),
    );
  }
}
