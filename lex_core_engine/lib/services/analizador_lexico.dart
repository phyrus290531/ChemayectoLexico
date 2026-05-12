import '../models/token_lexico.dart';
import '../models/error_lexico.dart';

/// Servicio de Análisis Léxico.
///
/// Implementa la lógica completa del analizador léxico para el
/// motor de videojuegos basado en texto LEX-CORE ENGINE.
/// Reconoce comandos, identificadores, números, símbolos y comentarios.
class AnalizadorLexico {
  /// Texto fuente a analizar
  String textoFuente;

  /// Lista de tokens reconocidos durante el análisis
  List<TokenLexico> tokens = [];

  /// Lista de errores léxicos encontrados durante el análisis
  List<ErrorLexico> errores = [];

  /// Comandos válidos reconocidos por el motor
  static const List<String> comandosValidos = [
    'MOVER', 'ATACAR', 'USAR', 'HABLAR', 'TOMAR', 'SOLTAR',
    'EXAMINAR', 'ABRIR', 'CERRAR', 'EMPUJAR', 'TIRAR', 'MIRAR',
    'CORRER', 'SALTAR', 'NADAR', 'ESCALAR', 'LANZAR', 'EQUIPAR',
    'GUARDAR', 'CARGAR',
  ];

  /// Símbolos válidos de un solo carácter
  static const Set<String> simbolosSimples = {'(', ')', ',', ';', ':'};

  AnalizadorLexico({this.textoFuente = ''});

  /// Ejecuta el análisis léxico sobre el [textoFuente].
  ///
  /// Recorre el texto carácter por carácter, identificando tokens
  /// válidos y reportando errores léxicos.
  void analizar() {
    tokens.clear();
    errores.clear();

    final lineas = textoFuente.split('\n');

    for (int i = 0; i < lineas.length; i++) {
      final linea = lineas[i];
      final numLinea = i + 1;
      int col = 0;

      while (col < linea.length) {
        final char = linea[col];

        // Ignorar espacios en blanco y tabulaciones
        if (char == ' ' || char == '\t' || char == '\r') {
          col++;
          continue;
        }

        // Comentarios: desde # hasta el final de la línea
        if (char == '#') {
          final comentario = linea.substring(col);
          tokens.add(TokenLexico(
            tipo: 'COMENTARIO',
            valor: comentario,
            linea: numLinea,
            columna: col + 1,
          ));
          break; // El resto de la línea es comentario
        }

        // Operador flecha: ->
        if (char == '-' && col + 1 < linea.length && linea[col + 1] == '>') {
          tokens.add(TokenLexico(
            tipo: 'FLECHA',
            valor: '->',
            linea: numLinea,
            columna: col + 1,
          ));
          col += 2;
          continue;
        }

        // Guion solo: error
        if (char == '-') {
          errores.add(ErrorLexico(
            caracter: '-',
            linea: numLinea,
            columna: col + 1,
            mensaje: "Símbolo '-' no reconocido. ¿Falta '>' para formar '->'?",
          ));
          col++;
          continue;
        }

        // Símbolos válidos de un solo carácter
        if (simbolosSimples.contains(char)) {
          String tipo;
          switch (char) {
            case '(':
              tipo = 'PARENTESIS_IZQ';
              break;
            case ')':
              tipo = 'PARENTESIS_DER';
              break;
            case ',':
              tipo = 'COMA';
              break;
            case ';':
              tipo = 'PUNTO_COMA';
              break;
            case ':':
              tipo = 'DOS_PUNTOS';
              break;
            default:
              tipo = 'SIMBOLO';
          }
          tokens.add(TokenLexico(
            tipo: tipo,
            valor: char,
            linea: numLinea,
            columna: col + 1,
          ));
          col++;
          continue;
        }

        // Números: secuencia de dígitos
        if (_esDigito(char)) {
          final inicio = col;
          String numero = '';
          while (col < linea.length && _esDigito(linea[col])) {
            numero += linea[col];
            col++;
          }

          // Verificar si el número es seguido por letras (identificador inválido)
          if (col < linea.length && (_esLetra(linea[col]) || linea[col] == '_')) {
            String palabra = numero;
            while (col < linea.length &&
                (_esLetra(linea[col]) || _esDigito(linea[col]) || linea[col] == '_')) {
              palabra += linea[col];
              col++;
            }
            errores.add(ErrorLexico(
              caracter: palabra,
              linea: numLinea,
              columna: inicio + 1,
              mensaje: "'$palabra' no es válido: los identificadores no pueden iniciar con un número.",
            ));
            continue;
          }

          tokens.add(TokenLexico(
            tipo: 'NUMERO',
            valor: numero,
            linea: numLinea,
            columna: inicio + 1,
          ));
          continue;
        }

        // Palabras: letras, dígitos y guion bajo
        if (_esLetra(char) || char == '_') {
          final inicio = col;
          String palabra = '';
          while (col < linea.length &&
              (_esLetra(linea[col]) || _esDigito(linea[col]) || linea[col] == '_')) {
            palabra += linea[col];
            col++;
          }

          // Verificar si es un comando (todo en mayúsculas)
          if (_esTodoMayusculas(palabra)) {
            if (comandosValidos.contains(palabra)) {
              tokens.add(TokenLexico(
                tipo: 'COMANDO',
                valor: palabra,
                linea: numLinea,
                columna: inicio + 1,
              ));
            } else {
              // Comando no reconocido, intentar sugerir
              final sugerencia = _sugerirComando(palabra);
              final mensajeSugerencia = sugerencia != null
                  ? " ¿Quisiste decir $sugerencia?"
                  : "";
              errores.add(ErrorLexico(
                caracter: palabra,
                linea: numLinea,
                columna: inicio + 1,
                mensaje: "Comando '$palabra' no reconocido.$mensajeSugerencia",
              ));
            }
            continue;
          }

          // Verificar si inicia con mayúscula pero no es todo mayúsculas
          if (_esLetraMayuscula(palabra[0]) && !_esTodoMayusculas(palabra)) {
            errores.add(ErrorLexico(
              caracter: palabra,
              linea: numLinea,
              columna: inicio + 1,
              mensaje: "'$palabra' no es un comando válido. Los comandos deben estar en MAYÚSCULAS.",
            ));
            continue;
          }

          // Verificar identificador válido: solo minúsculas, dígitos y guion bajo
          if (_esIdentificadorValido(palabra)) {
            tokens.add(TokenLexico(
              tipo: 'IDENTIFICADOR',
              valor: palabra,
              linea: numLinea,
              columna: inicio + 1,
            ));
          } else {
            errores.add(ErrorLexico(
              caracter: palabra,
              linea: numLinea,
              columna: inicio + 1,
              mensaje: "Identificador '$palabra' inválido: solo se permiten minúsculas, dígitos y guion bajo.",
            ));
          }
          continue;
        }

        // Carácter no reconocido
        errores.add(ErrorLexico(
          caracter: char,
          linea: numLinea,
          columna: col + 1,
          mensaje: "Símbolo '$char' no reconocido en el lenguaje.",
        ));
        col++;
      }
    }
  }

  /// Verifica si un carácter es un dígito (0-9)
  bool _esDigito(String c) {
    return c.codeUnitAt(0) >= 48 && c.codeUnitAt(0) <= 57;
  }

  /// Verifica si un carácter es una letra (a-z, A-Z)
  bool _esLetra(String c) {
    final code = c.codeUnitAt(0);
    return (code >= 65 && code <= 90) || (code >= 97 && code <= 122);
  }

  /// Verifica si un carácter es una letra mayúscula (A-Z)
  bool _esLetraMayuscula(String c) {
    final code = c.codeUnitAt(0);
    return code >= 65 && code <= 90;
  }

  /// Verifica si toda la palabra está en mayúsculas
  bool _esTodoMayusculas(String palabra) {
    for (int i = 0; i < palabra.length; i++) {
      final c = palabra[i];
      if (c == '_') continue;
      if (!_esLetraMayuscula(c) && !_esDigito(c)) return false;
    }
    // Al menos una letra mayúscula
    return palabra.contains(RegExp(r'[A-Z]'));
  }

  /// Verifica si una palabra es un identificador válido.
  /// Debe iniciar con letra minúscula o guion bajo y contener
  /// solo minúsculas, dígitos y guion bajo.
  bool _esIdentificadorValido(String palabra) {
    if (palabra.isEmpty) return false;
    final primerChar = palabra[0];
    // Debe iniciar con minúscula o guion bajo
    if (!_esLetraMinuscula(primerChar) && primerChar != '_') return false;
    // El resto solo puede ser minúsculas, dígitos o guion bajo
    for (int i = 1; i < palabra.length; i++) {
      final c = palabra[i];
      if (!_esLetraMinuscula(c) && !_esDigito(c) && c != '_') return false;
    }
    return true;
  }

  /// Verifica si un carácter es una letra minúscula (a-z)
  bool _esLetraMinuscula(String c) {
    final code = c.codeUnitAt(0);
    return code >= 97 && code <= 122;
  }

  /// Intenta sugerir un comando válido similar al comando no reconocido.
  /// Usa distancia de edición simple.
  String? _sugerirComando(String comando) {
    int mejorDistancia = 999;
    String? mejorSugerencia;

    for (final valido in comandosValidos) {
      final dist = _distanciaLevenshtein(comando, valido);
      if (dist < mejorDistancia && dist <= 2) {
        mejorDistancia = dist;
        mejorSugerencia = valido;
      }
    }
    return mejorSugerencia;
  }

  /// Calcula la distancia de Levenshtein entre dos cadenas.
  int _distanciaLevenshtein(String a, String b) {
    final m = a.length;
    final n = b.length;
    final dp = List.generate(m + 1, (_) => List.filled(n + 1, 0));

    for (int i = 0; i <= m; i++) {
      dp[i][0] = i;
    }
    for (int j = 0; j <= n; j++) {
      dp[0][j] = j;
    }

    for (int i = 1; i <= m; i++) {
      for (int j = 1; j <= n; j++) {
        final costo = a[i - 1] == b[j - 1] ? 0 : 1;
        dp[i][j] = [
          dp[i - 1][j] + 1,
          dp[i][j - 1] + 1,
          dp[i - 1][j - 1] + costo,
        ].reduce((a, b) => a < b ? a : b);
      }
    }
    return dp[m][n];
  }

  /// Retorna el número total de líneas analizadas
  int get lineasAnalizadas {
    if (textoFuente.trim().isEmpty) return 0;
    return textoFuente.split('\n').where((l) => l.trim().isNotEmpty).length;
  }

  /// Retorna true si el análisis no encontró errores
  bool get esValido => errores.isEmpty && tokens.isNotEmpty;
}
