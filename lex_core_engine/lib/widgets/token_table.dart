import 'package:flutter/material.dart';
import '../models/token_lexico.dart';

/// Widget de tabla de tokens.
///
/// Muestra los tokens encontrados durante el análisis léxico
/// en una tabla formateada con estilo consola/cyberpunk.
class TokenTable extends StatelessWidget {
  /// Lista de tokens a mostrar
  final List<TokenLexico> tokens;

  const TokenTable({
    super.key,
    required this.tokens,
  });

  /// Retorna el color correspondiente al tipo de token
  Color _colorPorTipo(String tipo) {
    switch (tipo) {
      case 'COMANDO':
        return const Color(0xFF00E676); // Verde neón
      case 'IDENTIFICADOR':
        return const Color(0xFF00BCD4); // Cian
      case 'NUMERO':
        return const Color(0xFFFF9800); // Naranja
      case 'PARENTESIS_IZQ':
      case 'PARENTESIS_DER':
        return const Color(0xFFFFEB3B); // Amarillo
      case 'COMA':
      case 'PUNTO_COMA':
      case 'DOS_PUNTOS':
        return const Color(0xFF9E9E9E); // Gris
      case 'FLECHA':
        return const Color(0xFFE040FB); // Morado
      case 'COMENTARIO':
        return const Color(0xFF607D8B); // Gris azulado
      default:
        return const Color(0xFFCFD8DC);
    }
  }

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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.grid_on_rounded,
                      color: Color(0xFF00E676),
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Tabla de Tokens',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                // Badge con cantidad de tokens
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00E676).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF00E676).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    '${tokens.length}',
                    style: const TextStyle(
                      color: Color(0xFF00E676),
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
          if (tokens.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'No hay tokens. Ejecuta el analizador.',
                  style: TextStyle(
                    color: Color(0xFF5A5E6A),
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            )
          else
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
                columnSpacing: 24,
                horizontalMargin: 16,
                columns: const [
                  DataColumn(label: Text('NO.')),
                  DataColumn(label: Text('VALOR')),
                  DataColumn(label: Text('TIPO')),
                  DataColumn(label: Text('LÍNEA')),
                  DataColumn(label: Text('COLUMNA')),
                ],
                rows: List.generate(tokens.length, (index) {
                  final token = tokens[index];
                  final colorTipo = _colorPorTipo(token.tipo);
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
                      DataCell(Text(
                        token.valor,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: colorTipo.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: colorTipo.withValues(alpha: 0.4),
                            ),
                          ),
                          child: Text(
                            token.tipo,
                            style: TextStyle(
                              color: colorTipo,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'monospace',
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      DataCell(Text(
                        '${token.linea}',
                        style: const TextStyle(
                          color: Color(0xFFCFD8DC),
                          fontSize: 13,
                          fontFamily: 'monospace',
                        ),
                      )),
                      DataCell(Text(
                        '${token.columna}',
                        style: const TextStyle(
                          color: Color(0xFFCFD8DC),
                          fontSize: 13,
                          fontFamily: 'monospace',
                        ),
                      )),
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
