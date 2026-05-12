import 'package:flutter/material.dart';
import '../services/analizador_lexico.dart';

/// Widget de chips de comandos permitidos.
///
/// Muestra todos los comandos válidos reconocidos por el analizador léxico
/// como chips/etiquetas con colores neón alternados.
class CommandChips extends StatelessWidget {
  const CommandChips({super.key});

  /// Colores neón para los chips de comandos
  static const List<Color> _coloresChip = [
    Color(0xFF00E676), // Verde neón
    Color(0xFF00BCD4), // Cian
    Color(0xFFE040FB), // Morado
    Color(0xFF00E5FF), // Cian claro
    Color(0xFF76FF03), // Verde lima
    Color(0xFFFFD740), // Ámbar
    Color(0xFF448AFF), // Azul
    Color(0xFFFF4081), // Rosa
    Color(0xFF69F0AE), // Verde menta
    Color(0xFFB388FF), // Lavanda
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D23),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF2A2D35),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          const Row(
            children: [
              Icon(
                Icons.terminal_rounded,
                color: Color(0xFF00E676),
                size: 16,
              ),
              SizedBox(width: 8),
              Text(
                'COMANDOS PERMITIDOS',
                style: TextStyle(
                  color: Color(0xFF8B8F9A),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(
              AnalizadorLexico.comandosValidos.length,
              (index) {
                final comando = AnalizadorLexico.comandosValidos[index];
                final color = _coloresChip[index % _coloresChip.length];
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: color.withValues(alpha: 0.35),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    comando,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'monospace',
                      letterSpacing: 0.8,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
