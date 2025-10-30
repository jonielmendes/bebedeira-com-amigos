import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import '../models/game_data.dart';
import '../models/categoria.dart';
import '../models/carta.dart';

class GameScreen extends StatefulWidget {
  final GameData gameData;
  final Categoria? categoria;

  const GameScreen({
    super.key,
    required this.gameData,
    this.categoria,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late List<Carta> _cartas;
  late List<Carta> _cartasRestantes;
  Carta? _cartaAtual;
  bool _isFlipped = false;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  int _cartasViradas = 0;
  List<String> _regrasAtivas = [];

  @override
  void initState() {
    super.initState();
    _setupCards();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
  }

  void _setupCards() {
    if (widget.categoria != null) {
      _cartas = widget.gameData.cartas
          .where((carta) => carta.categoria == widget.categoria!.id)
          .toList();
    } else {
      _cartas = List.from(widget.gameData.cartas);
    }
    _cartas.shuffle();
    _cartasRestantes = List.from(_cartas);
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _nextCard() {
    if (_cartasRestantes.isEmpty) {
      _showGameOverDialog();
      return;
    }

    setState(() {
      _isFlipped = false;
      _cartaAtual = _cartasRestantes.removeAt(0);
      _cartasViradas++;

      // Add rules if it's a rule card
      if (_cartaAtual!.tipo == 'regra') {
        _regrasAtivas.add(_cartaAtual!.texto);
      }
    });
  }

  void _flipCard() {
    if (_isFlipped) return;

    setState(() {
      _isFlipped = true;
    });
    _flipController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1a1a2e), // Azul escuro elegante
              Color(0xFF16213e), // Azul marinho profundo
              Color(0xFF0f3460), // Azul médio
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),

              // Rules indicator
              if (_regrasAtivas.isNotEmpty) _buildRulesIndicator(),

              // Card area
              Expanded(
                child: Center(
                  child: _cartaAtual == null
                      ? _buildInitialCard()
                      : _buildCard(),
                ),
              ),

              // Stats and controls
              _buildControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.categoria?.nome ?? 'Modo Aleatório',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Carta $_cartasViradas de ${_cartas.length}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white, size: 28),
            onPressed: () {
              setState(() {
                _setupCards();
                _cartaAtual = null;
                _cartasViradas = 0;
                _isFlipped = false;
                _regrasAtivas.clear();
                _flipController.reset();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRulesIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.orange, width: 2),
      ),
      child: Row(
        children: [
          const Icon(Icons.rule, color: Colors.white, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '${_regrasAtivas.length} regra(s) ativa(s) • Toque para ver',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: _showActiveRules,
          ),
        ],
      ),
    );
  }

  Widget _buildInitialCard() {
    return GestureDetector(
      onTap: _nextCard,
      child: Container(
        width: 300,
        height: 450,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '🃏',
              style: TextStyle(fontSize: 100),
            ),
            const SizedBox(height: 20),
            Text(
              'Toque para começar!',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard() {
    return GestureDetector(
      onTap: _isFlipped ? null : _flipCard,
      child: AnimatedBuilder(
        animation: _flipAnimation,
        builder: (context, child) {
          final angle = _flipAnimation.value * pi;
          final transform = Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle);

          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: angle > pi / 2
                ? Transform(
                    transform: Matrix4.identity()..rotateY(pi),
                    alignment: Alignment.center,
                    child: _buildCardFront(),
                  )
                : _buildCardBack(),
          );
        },
      ),
    );
  }

  Widget _buildCardBack() {
    return Container(
      width: 300,
      height: 450,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0f3460),
            Color(0xFF16213e),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Pattern
          ...List.generate(50, (index) {
            final random = Random(index);
            return Positioned(
              left: random.nextDouble() * 270,
              top: random.nextDouble() * 420,
              child: Text(
                '🍺',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            );
          }),
          // Center text
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '🎯',
                  style: TextStyle(fontSize: 80),
                ),
                const SizedBox(height: 20),
                Text(
                  'TOQUE PARA VIRAR',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardFront() {
    final carta = _cartaAtual!;
    final colors = _getCardColors(carta.nivel);

    return Container(
      width: 300,
      height: 450,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${carta.nivelEmoji} ${carta.nivel.toUpperCase()}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  carta.tipoEmoji,
                  style: const TextStyle(fontSize: 32),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Main text
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Text(
                    carta.texto,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Drinks info
            _buildDrinksInfo(carta),

            if (carta.restricao != null)
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    carta.restricao!,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrinksInfo(Carta carta) {
    String info = '';
    String emoji = '🍺';

    if (carta.goles != null) {
      info = '${carta.goles} gole${carta.goles! > 1 ? 's' : ''}';
    } else if (carta.golesSePular != null) {
      info = '${carta.golesSePular} gole${carta.golesSePular! > 1 ? 's' : ''} se pular';
      emoji = '⚠️';
    } else if (carta.golesPenalidade != null) {
      info = '${carta.golesPenalidade} gole${carta.golesPenalidade! > 1 ? 's' : ''} de penalidade';
      emoji = '⚠️';
    } else if (carta.golesDistribuir != null) {
      info = 'Distribua ${carta.golesDistribuir} gole${carta.golesDistribuir! > 1 ? 's' : ''}';
      emoji = '🎁';
    }

    if (info.isEmpty) return const SizedBox.shrink();

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 10),
            Text(
              info,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          // Cards remaining
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                const Icon(Icons.style, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  '${_cartasRestantes.length} restantes',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Next button
          GestureDetector(
            onTap: _isFlipped ? _nextCard : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              decoration: BoxDecoration(
                gradient: _isFlipped
                    ? const LinearGradient(
                        colors: [Color(0xFF43E97B), Color(0xFF38F9D7)],
                      )
                    : LinearGradient(
                        colors: [
                          Colors.grey.shade600,
                          Colors.grey.shade700,
                        ],
                      ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: _isFlipped
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  Text(
                    'PRÓXIMA',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getCardColors(String nivel) {
    switch (nivel) {
      case 'leve':
        return [const Color(0xFF43E97B), const Color(0xFF38F9D7)];
      case 'medio':
        return [const Color(0xFFFA709A), const Color(0xFFFEE140)];
      case 'pesado':
        return [const Color(0xFFFF6B6B), const Color(0xFFFF0844)];
      default:
        return [const Color(0xFF667EEA), const Color(0xFF764BA2)];
    }
  }

  void _showActiveRules() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF8E2DE2),
                const Color(0xFF4A00E0),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '📜 Regras Ativas',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              ..._regrasAtivas.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${entry.key + 1}.',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _regrasAtivas.clear();
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        'LIMPAR TODAS',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF8E2DE2),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        'FECHAR',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF8E2DE2),
                const Color(0xFF4A00E0),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '🎉',
                style: TextStyle(fontSize: 80),
              ),
              const SizedBox(height: 20),
              Text(
                'Fim do Jogo!',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Vocês viraram todas as ${_cartas.length} cartas!',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          _setupCards();
                          _cartaAtual = null;
                          _cartasViradas = 0;
                          _isFlipped = false;
                          _regrasAtivas.clear();
                          _flipController.reset();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF8E2DE2),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        'JOGAR DE NOVO',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.3),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        'VOLTAR',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
