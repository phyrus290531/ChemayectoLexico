import 'package:flutter/material.dart';

/// Widget de tarjeta de resumen para el panel de estadísticas.
///
/// Muestra un valor numérico o texto con un ícono, título
/// y acento de color personalizable. Diseñado con estilo
/// cyberpunk/consola oscura.
class SummaryCard extends StatelessWidget {
  /// Título superior de la tarjeta (ej: "TOKENS ENCONTRADOS")
  final String titulo;

  /// Valor principal a mostrar (ej: "24" o "Válido")
  final String valor;

  /// Ícono a mostrar junto al valor
  final IconData icono;

  /// Color de acento para el ícono y borde superior
  final Color color;

  const SummaryCard({
    super.key,
    required this.titulo,
    required this.valor,
    required this.icono,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D23),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF2A2D35),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Borde superior con acento de color
          Container(
            height: 2,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                Text(
                  titulo,
                  style: const TextStyle(
                    color: Color(0xFF8B8F9A),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                // Valor e ícono
                Row(
                  children: [
                    Text(
                      valor,
                      style: TextStyle(
                        color: color,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'monospace',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      icono,
                      color: color,
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
