import 'package:flutter/material.dart';

class MetricInputCard extends StatelessWidget {
  final String title;
  final String placeholder;
  final bool checked;
  final String value;
  final TextInputType keyboardType;
  final ValueChanged<bool>? onCheckedChanged;
  final ValueChanged<String>? onValueChanged;

  const MetricInputCard({
    super.key,
    required this.title,
    required this.placeholder,
    this.checked = false,
    this.value = '',
    this.keyboardType = TextInputType.number,
    this.onCheckedChanged,
    this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  value: checked,
                  onChanged: (value) => onCheckedChanged?.call(value ?? false),
                ),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: checked
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            if (checked) ...[
              const SizedBox(height: 12),
              TextField(
                keyboardType: keyboardType,
                decoration: InputDecoration(
                  hintText: placeholder,
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onChanged: onValueChanged,
                controller: TextEditingController(text: value)
                  ..selection = TextSelection.fromPosition(
                    TextPosition(offset: value.length),
                  ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
