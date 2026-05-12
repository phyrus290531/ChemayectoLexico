import 'package:flutter/material.dart';
import '../models/error_lexico.dart';

/// Widget de tabla de errores léxicos.
///
/// Muestra los errores encontrados durante el análisis léxico
/// en una tabla formateada con estilo consola/cyberpunk.
/// Solo se muestra si hay errores.
class ErrorTable extends StatelessWidget {
  /// Lista de errores a mostrar
  final List<ErrorLexico> errores;

  const ErrorTable({
    super.key,
    required this.errores,
  });

  @override
  Widget build(BuildContext context) {
    if (errores.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D23),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF3D1F1F),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Borde superior rojo
          Container(
            height: 2,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF1744), Color(0xFFFF5252)],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
          ),
          // Encabezado
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      color: Color(0xFFFF1744),
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Errores Léxicos',
                      style: TextStyle(
                        color: Color(0xFFFF1744),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                // Badge con cantidad de errores
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF1744).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFFF1744).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    '${errores.length}',
                    style: const TextStyle(
                      color: Color(0xFFFF1744),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Tabla
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                const Color(0xFF12141A),
              ),
              dataRowColor: WidgetStateProperty.resolveWith<Color>(
                (states) => const Color(0xFF1A1D23),
              ),
              headingTextStyle: const TextStyle(
                color: Color(0xFF8B8F9A),
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                fontFamily: 'monospace',
              ),
              columnSpacing: 20,
              horizontalMargin: 16,
              columns: const [
                DataColumn(label: Text('NO.')),
                DataColumn(label: Text('CARÁCTER')),
                DataColumn(label: Text('LÍNEA')),
                DataColumn(label: Text('COLUMNA')),
                DataColumn(label: Text('DESCRIPCIÓN')),
              ],
              rows: List.generate(errores.length, (index) {
                final error = errores[index];
                return DataRow(
                  cells: [
                    DataCell(Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Color(0xFF5A5E6A),
                        fontSize: 13,
                        fontFamily: 'monospace',
                      ),
                    )),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF1744).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: const Color(0xFFFF1744).withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          error.caracter,
                          style: const TextStyle(
                            color: Color(0xFFFF5252),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    ),
                    DataCell(Text(
                      '${error.linea}',
                      style: const TextStyle(
                        color: Color(0xFFCFD8DC),
                        fontSize: 13,
                        fontFamily: 'monospace',
                      ),
                    )),
                    DataCell(Text(
                      '${error.columna}',
                      style: const TextStyle(
                        color: Color(0xFFCFD8DC),
                        fontSize: 13,
                        fontFamily: 'monospace',
                      ),
                    )),
                    DataCell(
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 350),
                        child: Text(
                          error.mensaje,
                          style: const TextStyle(
                            color: Color(0xFFFFAB91),
                            fontSize: 12,
                            fontFamily: 'monospace',
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
