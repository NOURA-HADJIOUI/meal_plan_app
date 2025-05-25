import 'package:flutter/material.dart';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  final Widget nextPage;
  final Duration duration;

  const SplashScreen({
    super.key,
    required this.nextPage,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late AnimationController _rotationController;
  late AnimationController _pulseController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _scaleController.forward();

    await Future.delayed(const Duration(milliseconds: 400));
    _fadeController.forward();

    await Future.delayed(const Duration(milliseconds: 600));
    _rotationController.forward();

    await Future.delayed(const Duration(milliseconds: 800));
    _pulseController.repeat(reverse: true);

    await Future.delayed(widget.duration);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              widget.nextPage,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = const Offset(1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.ease;
            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }
 @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;
    final bool isTablet = screenWidth > 600;
    final bool isLandscape = screenWidth > screenHeight;
    
    // Calcul des tailles responsive
    final double logoSize = _getResponsiveLogoSize(screenWidth, isTablet);
    final double iconSize = logoSize * 0.5;
    final double titleFontSize = _getResponsiveTitleSize(screenWidth, isTablet);
    final double subtitleFontSize = _getResponsiveSubtitleSize(screenWidth, isTablet);
    final double spacing = _getResponsiveSpacing(screenHeight, isLandscape);
    final int particleCount = _getParticleCount(screenWidth);
    
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.orange.shade300,
                Colors.orange.shade600,
                Colors.deepOrange.shade700,
              ],
            ),
          ),
          child: Stack(
            children: [
              // Particules flottantes en arrière-plan (responsive)
              ...List.generate(particleCount, (index) => _buildFloatingParticle(index)),
              
              // Contenu principal
              Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: spacing * 0.5,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo animé (responsive)
                        AnimatedBuilder(
                          animation: Listenable.merge([
                            _scaleAnimation,
                            _rotationAnimation,
                            _pulseAnimation,
                          ]),
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _scaleAnimation.value * _pulseAnimation.value,
                              child: Transform.rotate(
                                angle: _rotationAnimation.value * 0.1,
                                child: Container(
                                  width: logoSize,
                                  height: logoSize,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: logoSize * 0.16,
                                        offset: Offset(0, logoSize * 0.08),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.restaurant_menu,
                                    size: iconSize,
                                    color: Colors.orange.shade600,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        
                        SizedBox(height: spacing),
                        
                        // Nom de l'application (responsive)
                        AnimatedBuilder(
                          animation: _fadeAnimation,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _fadeAnimation.value,
                              child: Column(
                                children: [
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: screenWidth * 0.9,
                                    ),
                                    child: ShaderMask(
                                      shaderCallback: (bounds) => LinearGradient(
                                        colors: [
                                          Colors.white,
                                          Colors.orange.shade100,
                                        ],
                                      ).createShader(bounds),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          'YumPlan',
                                          style: TextStyle(
                                            fontSize: titleFontSize,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                            letterSpacing: titleFontSize * 0.06,
                                            fontFamily: 'Pacifico',
                                            shadows: [
                                              Shadow(
                                                offset: Offset(titleFontSize * 0.04, titleFontSize * 0.04),
                                                blurRadius: titleFontSize * 0.08,
                                                color: Colors.black26,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  
                                  SizedBox(height: spacing * 0.3),
                                  
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: screenWidth * 0.85,
                                    ),
                                    child: Text(
                                      'Weekly Meal Planning Made Easy',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: subtitleFontSize,
                                        color: Colors.white.withOpacity(0.9),
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: subtitleFontSize * 0.08,
                                        fontFamily: 'Quicksand',
                                        height: 1.3,
                                        shadows: [
                                          Shadow(
                                            offset: Offset(subtitleFontSize * 0.05, subtitleFontSize * 0.05),
                                            blurRadius: subtitleFontSize * 0.1,
                                            color: Colors.black26,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        
                        SizedBox(height: spacing * 1.5),
                        
                        // Indicateur de chargement (responsive)
                        AnimatedBuilder(
                          animation: _fadeAnimation,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _fadeAnimation.value,
                              child: SizedBox(
                                width: _getResponsiveLoadingSize(screenWidth, isTablet),
                                height: _getResponsiveLoadingSize(screenWidth, isTablet),
                                child: CircularProgressIndicator(
                                  strokeWidth: isTablet ? 4 : 3,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Méthodes helper pour les tailles responsive
  double _getResponsiveLogoSize(double screenWidth, bool isTablet) {
    if (isTablet) {
      return screenWidth * 0.2; // 20% de la largeur sur tablette
    } else if (screenWidth < 350) {
      return 100; // Petits écrans
    } else if (screenWidth > 400) {
      return 140; // Grands écrans
    }
    return 120; // Écrans moyens
  }
  
  double _getResponsiveTitleSize(double screenWidth, bool isTablet) {
    if (isTablet) {
      return screenWidth * 0.12; // 12% de la largeur sur tablette
    } else if (screenWidth < 350) {
      return 40; // Petits écrans
    } else if (screenWidth > 400) {
      return 56; // Grands écrans
    }
    return 48; // Écrans moyens
  }
  
  double _getResponsiveSubtitleSize(double screenWidth, bool isTablet) {
    if (isTablet) {
      return screenWidth * 0.04; // 4% de la largeur sur tablette
    } else if (screenWidth < 350) {
      return 14; // Petits écrans
    } else if (screenWidth > 400) {
      return 20; // Grands écrans
    }
    return 16; // Écrans moyens
  }
  
  double _getResponsiveSpacing(double screenHeight, bool isLandscape) {
    if (isLandscape) {
      return screenHeight * 0.05; // Moins d'espacement en paysage
    }
    return screenHeight * 0.08; // Espacement normal en portrait
  }
  
  double _getResponsiveLoadingSize(double screenWidth, bool isTablet) {
    if (isTablet) {
      return 50;
    } else if (screenWidth < 350) {
      return 35;
    }
    return 40;
  }
  
  int _getParticleCount(double screenWidth) {
    if (screenWidth > 800) {
      return 20; // Plus de particules sur grands écrans
    } else if (screenWidth < 350) {
      return 10; // Moins de particules sur petits écrans
    }
    return 15; // Nombre standard
  }

  Widget _buildFloatingParticle(int index) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final random = math.Random(index);
        final size = random.nextDouble() * 8 + 4;
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        final left = random.nextDouble() * screenWidth;
        final animationDuration = random.nextInt(3000) + 2000;
        
        return AnimatedBuilder(
          animation: _fadeController,
          builder: (context, child) {
            return Positioned(
              left: left,
              top: random.nextDouble() * screenHeight,
              child: Opacity(
                opacity: _fadeAnimation.value * 0.6,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: animationDuration),
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(
                        math.sin(value * 2 * math.pi) * (screenWidth * 0.05),
                        -value * (screenHeight * 0.15),
                      ),
                      child: Container(
                        width: size,
                        height: size,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}