import 'package:flutter/material.dart';

class MetricField {
  final int bovinueMPId;
  final String title;
  final String placeholder;
  final TextInputType keyboardType;
  bool checked;
  String value;

  MetricField({
    required this.bovinueMPId,
    required this.title,
    required this.placeholder,
    this.keyboardType = TextInputType.number,
    this.checked = false,
    this.value = '',
  });

  MetricField copyWith({
    int? bovinueMPId,
    String? title,
    String? placeholder,
    TextInputType? keyboardType,
    bool? checked,
    String? value,
  }) {
    return MetricField(
      bovinueMPId: bovinueMPId ?? this.bovinueMPId,
      title: title ?? this.title,
      placeholder: placeholder ?? this.placeholder,
      keyboardType: keyboardType ?? this.keyboardType,
      checked: checked ?? this.checked,
      value: value ?? this.value,
    );
  }
}

// Métricas predefinidas para bovinos
class PredefinedMetrics {
  static List<MetricField> getDefaultMetrics() {
    return [
      MetricField(
        bovinueMPId: 1,
        title: 'Producción de leche por vaca/día',
        placeholder: 'Ingrese litros por día',
        keyboardType: TextInputType.number,
      ),
      MetricField(
        bovinueMPId: 2,
        title: 'Contenido de grasa y proteína',
        placeholder: 'Ingrese porcentaje (%)',
        keyboardType: TextInputType.number,
      ),
      MetricField(
        bovinueMPId: 3,
        title: 'Ganancia de peso diaria (GMD)',
        placeholder: 'Ingrese gramos por día',
        keyboardType: TextInputType.number,
      ),
      MetricField(
        bovinueMPId: 4,
        title: 'Índice de conversión alimenticia',
        placeholder: 'Ingrese índice',
        keyboardType: TextInputType.number,
      ),
      MetricField(
        bovinueMPId: 5,
        title: 'Tasa de preñez',
        placeholder: 'Ingrese porcentaje (%)',
        keyboardType: TextInputType.number,
      ),
      MetricField(
        bovinueMPId: 6,
        title: 'Tasa de concepción',
        placeholder: 'Ingrese porcentaje (%)',
        keyboardType: TextInputType.number,
      ),
    ];
  }
}
