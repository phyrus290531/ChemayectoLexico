import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';

import 'models/token_lexico.dart';
import 'models/error_lexico.dart';
import 'services/analizador_lexico.dart';
import 'widgets/editor_panel.dart';
import 'widgets/summary_card.dart';
import 'widgets/token_table.dart';
import 'widgets/error_table.dart';
import 'widgets/command_chips.dart';

/// Punto de entrada de la aplicación LEX-CORE ENGINE.
void main() {
  runApp(const LexCoreEngineApp());
}

/// Widget raíz de la aplicación.
///
/// Configura el tema oscuro Material 3 y la navegación principal.
class LexCoreEngineApp extends StatelessWidget {
  const LexCoreEngineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LEX-CORE ENGINE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0A0C10),
        colorScheme: const ColorScheme.dark(
          surface: Color(0xFF0A0C10),
          primary: Color(0xFF00E676),
          secondary: Color(0xFF00BCD4),
          error: Color(0xFFFF1744),
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      ),
      home: const AnalyzerScreen(),
    );
  }
}

/// Pantalla principal del analizador léxico.
///
/// Contiene el editor de código, paneles de resumen, tablas de tokens
/// y errores, y la lista de comandos permitidos.
class AnalyzerScreen extends StatefulWidget {
  const AnalyzerScreen({super.key});

  @override
  State<AnalyzerScreen> createState() => _AnalyzerScreenState();
}

class _AnalyzerScreenState extends State<AnalyzerScreen>
    with SingleTickerProviderStateMixin {
  /// Controlador del editor de texto
  final TextEditingController _editorController = TextEditingController();

  /// Instancia del analizador léxico
  final AnalizadorLexico _analizador = AnalizadorLexico();

  /// Lista de tokens resultado del análisis
  List<TokenLexico> _tokens = [];

  /// Lista de errores resultado del análisis
  List<ErrorLexico> _errores = [];

  /// Número de líneas analizadas
  int _lineasAnalizadas = 0;

  /// Indica si ya se realizó un análisis
  bool _analisisRealizado = false;

  /// Índice del tab de navegación seleccionado
  int _selectedNavIndex = 0;

  /// Número de líneas en el editor
  int _lineCount = 1;

  /// Controlador de animación para efectos
  late AnimationController _animController;

  /// Texto de ejemplo inicial
  static const String _textoEjemplo =
      'MOVER(jugador, norte);\nATACAR(enemigo1, espada_fuego);\nTOMAR(llave_plata);';

  @override
  void initState() {
    super.initState();
    _editorController.text = _textoEjemplo;
    _editorController.addListener(_actualizarLineas);
    _actualizarLineas();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _editorController.removeListener(_actualizarLineas);
    _editorController.dispose();
    _animController.dispose();
    super.dispose();
  }

  /// Actualiza el conteo de líneas del editor
  void _actualizarLineas() {
    final lines = _editorController.text.split('\n').length;
    if (lines != _lineCount) {
      setState(() {
        _lineCount = lines < 1 ? 1 : lines;
      });
    }
  }

  /// Ejecuta el análisis léxico sobre el texto del editor
  void _analizarMision() {
    _analizador.textoFuente = _editorController.text;
    _analizador.analizar();

    setState(() {
      _tokens = List.from(_analizador.tokens);
      _errores = List.from(_analizador.errores);
      _lineasAnalizadas = _analizador.lineasAnalizadas;
      _analisisRealizado = true;
    });

    _animController.forward(from: 0);
  }

  /// Limpia el editor y todos los resultados del análisis
  void _limpiar() {
    setState(() {
      _editorController.clear();
      _tokens = [];
      _errores = [];
      _lineasAnalizadas = 0;
      _analisisRealizado = false;
      _lineCount = 1;
    });
  }

  /// Carga un archivo de texto usando file_picker.
  /// Si la carga falla o no está disponible, inserta el texto de ejemplo.
  Future<void> _cargarArchivo() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt'],
        withData: true,
      );

      if (result != null && result.files.single.bytes != null) {
        final contenido = utf8.decode(result.files.single.bytes!);
        setState(() {
          _editorController.text = contenido;
        });
      }
    } catch (e) {
      // Si file_picker no está disponible, cargar el texto de ejemplo
      setState(() {
        _editorController.text = _textoEjemplo;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Se cargó el texto de ejemplo.'),
            backgroundColor: const Color(0xFF1A1D23),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 1000;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0C10),
      body: Column(
        children: [
          // Barra superior
          _buildTopBar(isWide),
          // Contenido principal
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: isWide ? _buildWideLayout() : _buildNarrowLayout(),
            ),
          ),
        ],
      ),
    );
  }

  /// Barra superior de la aplicación con logo, título y navegación
  Widget _buildTopBar(bool isWide) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF0E1017),
        border: Border(bottom: BorderSide(color: Color(0xFF1E2028), width: 1)),
      ),
      child: Row(
        children: [
          // Logo
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFF00E676).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF00E676).withValues(alpha: 0.3),
              ),
            ),
            child: const Icon(
              Icons.data_object_rounded,
              color: Color(0xFF00E676),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          // Título y subtítulo
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ChemaYecto',
                style: GoogleFonts.orbitron(
                  color: Colors.white,
                  fontSize: isWide ? 16 : 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                ),
              ),
              Text(
                'Motor de videojuegos basado en texto',
                style: TextStyle(
                  color: const Color(0xFF5A5E6A),
                  fontSize: isWide ? 11 : 9,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Botón de ícono estilizado para la barra superior
  Widget _buildIconButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1D23),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2A2D35)),
      ),
      child: Icon(icon, color: const Color(0xFF5A5E6A), size: 18),
    );
  }

  /// Layout para pantallas anchas (escritorio): dos columnas
  Widget _buildWideLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Columna izquierda: Editor + Comandos
        Expanded(
          flex: 5,
          child: Column(
            children: [
              SizedBox(
                height: 480,
                child: EditorPanel(
                  controller: _editorController,
                  onAnalizar: _analizarMision,
                  onLimpiar: _limpiar,
                  onCargarArchivo: _cargarArchivo,
                  lineCount: _lineCount,
                ),
              ),
              const SizedBox(height: 16),
              const CommandChips(),
            ],
          ),
        ),
        const SizedBox(width: 20),
        // Columna derecha: Resumen + Tablas
        Expanded(
          flex: 4,
          child: Column(
            children: [
              _buildSummaryGrid(),
              const SizedBox(height: 16),
              TokenTable(tokens: _tokens),
              const SizedBox(height: 16),
              ErrorTable(errores: _errores),
            ],
          ),
        ),
      ],
    );
  }

  /// Layout para pantallas angostas (móvil/tablet): una columna
  Widget _buildNarrowLayout() {
    return Column(
      children: [
        SizedBox(
          height: 420,
          child: EditorPanel(
            controller: _editorController,
            onAnalizar: _analizarMision,
            onLimpiar: _limpiar,
            onCargarArchivo: _cargarArchivo,
            lineCount: _lineCount,
          ),
        ),
        const SizedBox(height: 16),
        const CommandChips(),
        const SizedBox(height: 16),
        _buildSummaryGrid(),
        const SizedBox(height: 16),
        TokenTable(tokens: _tokens),
        const SizedBox(height: 16),
        ErrorTable(errores: _errores),
      ],
    );
  }

  /// Cuadrícula 2x2 con las tarjetas de resumen
  Widget _buildSummaryGrid() {
    final estado = !_analisisRealizado
        ? '—'
        : (_errores.isEmpty ? 'Válido' : 'Con errores');
    final estadoColor = !_analisisRealizado
        ? const Color(0xFF5A5E6A)
        : (_errores.isEmpty
              ? const Color(0xFF00E676)
              : const Color(0xFFFF1744));
    final estadoIcono = !_analisisRealizado
        ? Icons.remove_circle_outline
        : (_errores.isEmpty
              ? Icons.check_circle_outline_rounded
              : Icons.cancel_outlined);

    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.0,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        SummaryCard(
          titulo: 'TOKENS ENCONTRADOS',
          valor: _analisisRealizado ? '${_tokens.length}' : '—',
          icono: Icons.data_object_rounded,
          color: const Color(0xFF00BCD4),
        ),
        SummaryCard(
          titulo: 'ERRORES LÉXICOS',
          valor: _analisisRealizado ? '${_errores.length}' : '—',
          icono: _errores.isEmpty
              ? Icons.check_circle_outline
              : Icons.error_outline_rounded,
          color: _errores.isEmpty && _analisisRealizado
              ? const Color(0xFF00E676)
              : (_errores.isNotEmpty
                    ? const Color(0xFFFF1744)
                    : const Color(0xFF5A5E6A)),
        ),
        SummaryCard(
          titulo: 'LÍNEAS ANALIZADAS',
          valor: _analisisRealizado ? '$_lineasAnalizadas' : '—',
          icono: Icons.format_list_numbered_rounded,
          color: const Color(0xFF448AFF),
        ),
        SummaryCard(
          titulo: 'ESTADO GENERAL',
          valor: estado,
          icono: estadoIcono,
          color: estadoColor,
        ),
      ],
    );
  }
}
