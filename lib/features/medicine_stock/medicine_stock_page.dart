import 'package:flutter/material.dart';
import '../../models/medicine.dart';
import '../../services/medicine_service.dart';

class MedicineStockPage extends StatefulWidget {
  const MedicineStockPage({super.key});

  @override
  State<MedicineStockPage> createState() => _MedicineStockPageState();
}

class _MedicineStockPageState extends State<MedicineStockPage> {
  List<Medicine> _medicines = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMedicines();
  }

  Future<void> _loadMedicines() async {
    final medicines = await MedicineService.getMedicines();
    setState(() {
      _medicines = medicines;
      _isLoading = false;
    });
  }

  Future<void> _updateQuantity(Medicine medicine, int newQuantity) async {
    final updatedMedicine = Medicine(
      id: medicine.id,
      name: medicine.name,
      form: medicine.form,
      frequency: medicine.frequency,
      dailyFrequency: medicine.dailyFrequency,
      time: medicine.time,
      dosage: medicine.dosage,
      createdAt: medicine.createdAt,
      quantity: newQuantity,
    );

    await MedicineService.updateMedicine(updatedMedicine);
    await _loadMedicines();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${medicine.name} stock updated'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  void _showUpdateQuantityDialog(Medicine medicine) {
    final controller = TextEditingController(
      text: medicine.quantity.toString(),
    );
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.inventory_2, color: cs.primary, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Update Stock',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.primary,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              medicine.name,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Quantity',
                hintText: 'Enter quantity',
                suffixText: medicine.form,
                filled: true,
                fillColor: cs.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.add_circle_outline, color: cs.primary),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: cs.onSurface.withOpacity(0.6)),
            ),
          ),
          FilledButton(
            onPressed: () {
              final quantity = int.tryParse(controller.text) ?? 0;
              Navigator.pop(context);
              _updateQuantity(medicine, quantity);
            },
            style: FilledButton.styleFrom(
              backgroundColor: cs.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [cs.surface, cs.primary.withOpacity(0.05)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: cs.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.inventory_2,
                        color: cs.primary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Medicine Stock',
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(color: cs.primary),
                      )
                    : _medicines.isEmpty
                    ? _buildEmptyState(cs, textTheme)
                    : RefreshIndicator(
                        onRefresh: _loadMedicines,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: _medicines.length,
                          itemBuilder: (context, index) {
                            return _buildStockCard(
                              _medicines[index],
                              cs,
                              textTheme,
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme cs, TextTheme textTheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: cs.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                size: 80,
                color: cs.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No medicines yet',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Add medicines from the home page\nto start tracking your stock',
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(
                color: cs.onSurface.withOpacity(0.6),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStockCard(
    Medicine medicine,
    ColorScheme cs,
    TextTheme textTheme,
  ) {
    final isLowStock = medicine.quantity < medicine.dosage * 3;
    final isOutOfStock = medicine.quantity <= 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20),
        border: isOutOfStock
            ? Border.all(color: Colors.red, width: 2)
            : isLowStock
            ? Border.all(color: Colors.orange, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _showUpdateQuantityDialog(medicine),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Medicine Icon
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isOutOfStock
                              ? [Colors.red.shade400, Colors.red.shade600]
                              : isLowStock
                              ? [Colors.orange.shade400, Colors.orange.shade600]
                              : [cs.primary, cs.primary.withOpacity(0.7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.medication,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Medicine Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            medicine.name,
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: cs.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${medicine.dosage} ${medicine.form} per dose',
                            style: textTheme.bodyMedium?.copyWith(
                              color: cs.onSurface.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            medicine.formattedTime,
                            style: textTheme.bodySmall?.copyWith(
                              color: cs.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Quantity Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isOutOfStock
                            ? Colors.red.withOpacity(0.1)
                            : isLowStock
                            ? Colors.orange.withOpacity(0.1)
                            : cs.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            medicine.quantity.toString(),
                            style: textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isOutOfStock
                                  ? Colors.red
                                  : isLowStock
                                  ? Colors.orange
                                  : cs.primary,
                            ),
                          ),
                          Text(
                            medicine.form,
                            style: textTheme.bodySmall?.copyWith(
                              color: isOutOfStock
                                  ? Colors.red
                                  : isLowStock
                                  ? Colors.orange
                                  : cs.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Status and Action
                Row(
                  children: [
                    // Status Chip
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isOutOfStock
                              ? Colors.red.withOpacity(0.1)
                              : isLowStock
                              ? Colors.orange.withOpacity(0.1)
                              : Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isOutOfStock
                                  ? Icons.error
                                  : isLowStock
                                  ? Icons.warning_amber
                                  : Icons.check_circle,
                              color: isOutOfStock
                                  ? Colors.red
                                  : isLowStock
                                  ? Colors.orange
                                  : Colors.green,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isOutOfStock
                                  ? 'Out of Stock'
                                  : isLowStock
                                  ? 'Low Stock'
                                  : 'In Stock',
                              style: textTheme.bodyMedium?.copyWith(
                                color: isOutOfStock
                                    ? Colors.red
                                    : isLowStock
                                    ? Colors.orange
                                    : Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Update Button
                    ElevatedButton.icon(
                      onPressed: () => _showUpdateQuantityDialog(medicine),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cs.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.add, size: 20),
                      label: const Text('Update'),
                    ),
                  ],
                ),

                // Estimated Days Remaining
                if (medicine.quantity > 0) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: cs.onSurface.withOpacity(0.6),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Estimated: ${(medicine.quantity / medicine.dosage).floor()} doses remaining',
                          style: textTheme.bodySmall?.copyWith(
                            color: cs.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
