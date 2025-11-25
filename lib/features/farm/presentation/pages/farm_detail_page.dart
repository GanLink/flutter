import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ganlink/features/farm/domain/farm.dart';
import 'package:ganlink/features/farm/repositories/farm_repository.dart';

class FarmDetailPage extends StatefulWidget {
  final Farm farm;

  const FarmDetailPage({super.key, required this.farm});

  @override
  State<FarmDetailPage> createState() => _FarmDetailPageState();
}

class _FarmDetailPageState extends State<FarmDetailPage> {
  bool _isDeleting = false;

  Future<void> _deleteFarm() async {
    final repo = context.read<FarmRepository>();
    setState(() => _isDeleting = true);
    try {
      await repo.deleteFarm(widget.farm.id);
      if (!mounted) return;
      context.pop(true); // indicate deletion success
    } catch (e) {
      if (!mounted) return;
      setState(() => _isDeleting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No se pudo eliminar la farm: ${e.toString()}',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final farm = widget.farm;
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  farm.alias,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                IconButton(
                  onPressed: _isDeleting ? null : _deleteFarm,
                  icon: const Icon(Icons.close),
                  tooltip: 'Eliminar farm',
                ),
              ],
            ),
          ),
          if (_isDeleting)
            Container(
              color: Colors.black.withOpacity(0.1),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
