/// Modelo de datos para un Error Léxico.
///
/// Representa un error encontrado durante el análisis léxico,
/// incluyendo el carácter o palabra inválida, su posición y un mensaje descriptivo.
class ErrorLexico {
  /// Carácter o palabra que causó el error
  final String caracter;

  /// Número de línea donde se encontró el error (1-indexed)
  final int linea;

  /// Número de columna donde se encontró el error (1-indexed)
  final int columna;

  /// Mensaje descriptivo del error
  final String mensaje;

  const ErrorLexico({
    required this.caracter,
    required this.linea,
    required this.columna,
    required this.mensaje,
  });

  @override
  String toString() => 'Error("$caracter", L:$linea, C:$columna, $mensaje)';
}
