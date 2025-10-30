import 'package:flutter/material.dart';
import '../models/categoria.dart';
import '../models/game_data.dart';
import '../services/game_service.dart';
import 'game_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  List<Categoria> _categorias = [];
  GameData? _gameData;
  bool _isLoading = true;

  // Cores elegantes para cada categoria
  final Map<String, List<Color>> _categoryColors = {
    'eu_nunca': [const Color(0xFFe94560), const Color(0xFFf4538a)],
    'verdade_ou_desafio': [const Color(0xFF4facfe), const Color(0xFF00f2fe)],
    'desafios_rapidos': [const Color(0xFFfa709a), const Color(0xFFfee140)],
    'picante': [const Color(0xFFfc466b), const Color(0xFF3f5efb)],
    'party': [const Color(0xFF667eea), const Color(0xFF764ba2)],
    'regras': [const Color(0xFFf093fb), const Color(0xFFf5576c)],
    'votacao': [const Color(0xFF4facfe), const Color(0xFF00f2fe)],
  };

  // Ícones para cada categoria
  final Map<String, IconData> _categoryIcons = {
    'eu_nunca': Icons.sports_bar_rounded,
    'verdade_ou_desafio': Icons.psychology_rounded,
    'desafios_rapidos': Icons.flash_on_rounded,
    'picante': Icons.local_fire_department_rounded,
    'party': Icons.celebration_rounded,
    'regras': Icons.gavel_rounded,
    'votacao': Icons.how_to_vote_rounded,
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final gameData = await GameService.loadGameData();
    setState(() {
      _gameData = gameData;
      _categorias = gameData.categorias;
      _isLoading = false;
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
              Color(0xFF1a1a2e),
              Color(0xFF16213e),
              Color(0xFF0f3460),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),
              
              // Lista de categorias
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : _buildCategoriesList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Escolha a Categoria',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ou jogue no modo aleatório',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesList() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          // Botão Modo Aleatório
          _buildRandomModeButton(),
          const SizedBox(height: 25),
          
          // Cards de categorias
          ..._categorias.asMap().entries.map((entry) {
            int index = entry.key;
            Categoria categoria = entry.value;
            return _buildCategoryCard(categoria, index);
          }).toList(),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildRandomModeButton() {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 800),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            height: 75,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFe94560),
                  Color(0xFFf4538a),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.pink.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _startRandomMode(),
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.shuffle_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Modo Aleatório',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Surpresa a cada carta',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryCard(Categoria categoria, int index) {
    final colors = _categoryColors[categoria.id] ?? [Colors.purple, Colors.pink];
    final icon = _categoryIcons[categoria.id] ?? Icons.stars_rounded;
    
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 600 + (index * 100)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: colors,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: colors[0].withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _startGame(categoria),
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          // Ícone da categoria
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              icon,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          
                          // Texto da categoria
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  categoria.nome,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  categoria.descricao,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.9),
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          
                          // Seta
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _startGame(Categoria categoria) {
    if (_gameData == null) return;
    
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            GameScreen(gameData: _gameData!, categoria: categoria),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.easeInOutCubic;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  void _startRandomMode() {
    if (_gameData == null) return;
    
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            GameScreen(gameData: _gameData!, categoria: null), // null = modo aleatório
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}
