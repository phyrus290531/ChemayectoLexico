/// Modelo de datos para un Token Léxico.
///
/// Representa un token identificado durante el análisis léxico,
/// incluyendo su tipo, valor y posición en el código fuente.
class TokenLexico {
  /// Tipo del token (COMANDO, IDENTIFICADOR, NUMERO, etc.)
  final String tipo;

  /// Valor literal del token
  final String valor;

  /// Número de línea donde se encontró el token (1-indexed)
  final int linea;

  /// Número de columna donde se encontró el token (1-indexed)
  final int columna;

  const TokenLexico({
    required this.tipo,
    required this.valor,
    required this.linea,
    required this.columna,
  });

  @override
  String toString() => 'Token($tipo, "$valor", L:$linea, C:$columna)';
}
