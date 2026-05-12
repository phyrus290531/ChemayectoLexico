import 'package:flutter/material.dart';

/// Widget de panel de editor de código.
///
/// Simula un editor de código con números de línea, encabezado
/// con nombre de archivo y botones de acción. Diseñado con
/// estilo oscuro tipo terminal/IDE.
class EditorPanel extends StatelessWidget {
  /// Controlador del campo de texto del editor
  final TextEditingController controller;

  /// Callback cuando se presiona el botón "Analizar misión"
  final VoidCallback onAnalizar;

  /// Callback cuando se presiona el botón "Limpiar"
  final VoidCallback onLimpiar;

  /// Callback cuando se presiona "Cargar archivo"
  final VoidCallback onCargarArchivo;

  /// Número de líneas del editor para mostrar números de línea
  final int lineCount;

  const EditorPanel({
    super.key,
    required this.controller,
    required this.onAnalizar,
    required this.onLimpiar,
    required this.onCargarArchivo,
    this.lineCount = 1,
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Barra superior del editor
          _buildHeader(),
          // Área del editor con números de línea
          Expanded(
            child: _buildEditorArea(),
          ),
          // Barra inferior con botones
          _buildFooter(),
        ],
      ),
    );
  }

  /// Construye el encabezado del editor con nombre de archivo y botón de carga
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFF12141A),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF2A2D35),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.description_outlined,
            color: Color(0xFF5A5E6A),
            size: 16,
          ),
          const SizedBox(width: 8),
          const Text(
            'quest.txt',
            style: TextStyle(
              color: Color(0xFFCFD8DC),
              fontSize: 13,
              fontFamily: 'monospace',
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          // Botón cargar archivo
          InkWell(
            onTap: onCargarArchivo,
            borderRadius: BorderRadius.circular(6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2D35),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.upload_file_rounded,
                    color: Color(0xFF8B8F9A),
                    size: 14,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Cargar archivo',
                    style: TextStyle(
                      color: Color(0xFF8B8F9A),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Construye el área del editor con números de línea
  Widget _buildEditorArea() {
    return Container(
      color: const Color(0xFF12141A),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Columna de números de línea
          Container(
            width: 45,
            padding: const EdgeInsets.only(top: 14, right: 8),
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: Color(0xFF2A2D35),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(
                lineCount > 0 ? lineCount : 1,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  child: SizedBox(
                    height: 22.4, // Coincide con la altura de línea del texto
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Color(0xFF3D4150),
                        fontSize: 13,
                        fontFamily: 'monospace',
                        height: 1.6,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Campo de texto del editor
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              style: const TextStyle(
                color: Color(0xFFE0E0E0),
                fontSize: 14,
                fontFamily: 'monospace',
                height: 1.6,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(14),
                hintText: '// Escribe tus instrucciones aquí...',
                hintStyle: TextStyle(
                  color: Color(0xFF3D4150),
                  fontSize: 14,
                  fontFamily: 'monospace',
                  fontStyle: FontStyle.italic,
                ),
              ),
              cursorColor: const Color(0xFF00E676),
              cursorWidth: 2,
            ),
          ),
        ],
      ),
    );
  }

  /// Construye la barra inferior con los botones de acción
  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF12141A),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        border: Border(
          top: BorderSide(
            color: Color(0xFF2A2D35),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Botón Limpiar
          _buildButton(
            label: 'Limpiar',
            icon: Icons.cleaning_services_rounded,
            onTap: onLimpiar,
            isPrimary: false,
          ),
          const SizedBox(width: 16),
          // Botón Analizar misión
          _buildButton(
            label: 'Analizar misión',
            icon: Icons.play_arrow_rounded,
            onTap: onAnalizar,
            isPrimary: true,
          ),
        ],
      ),
    );
  }

  /// Construye un botón estilizado
  Widget _buildButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    final bgColor = isPrimary
        ? const Color(0xFF00E676)
        : const Color(0xFF2A2D35);
    final textColor = isPrimary
        ? const Color(0xFF0A0C10)
        : const Color(0xFFCFD8DC);
    final borderColor = isPrimary
        ? const Color(0xFF00E676)
        : const Color(0xFF3D4150);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: isPrimary
                ? [
                    BoxShadow(
                      color: const Color(0xFF00E676).withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: textColor, size: 16),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
