import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;

void main() {
  runApp(const Settings());
}

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    // Définir le style de la barre d'état
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    
    return MaterialApp(
      title: 'Paramètres',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const SettingsPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    final isLandscape = screenSize.width > screenSize.height;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Barre d'état personnalisée (masquée en mode paysage sur mobile)
            if (!isLandscape || isTablet) _buildStatusBar(context),
            
            // AppBar personnalisé
            _buildAppBar(context, isTablet),
            
            // Contenu principal
            Expanded(
              child: _buildMainContent(context, screenSize, isTablet, isLandscape),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBar(BuildContext context) {
    return Container(
      height: 44,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isTablet) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: isTablet ? 60 : 52,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
       
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, Size screenSize, bool isTablet, bool isLandscape) {
    final double horizontalPadding = _getHorizontalPadding(screenSize, isTablet);
    final double contentWidth = _getContentWidth(screenSize, isTablet);

    return SizedBox(
      width: double.infinity,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: contentWidth),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Section PROFILE
              _buildSectionHeader('PROFILE', isTablet, isLandscape),
              _buildSettingsCard(
                context,
                [
                  _buildLanguageItem(context, isTablet),
                ],
                isTablet,
              ),
              
              SizedBox(height: isLandscape ? 16 : 24),
              
              // Section OTHER
              _buildSectionHeader('OTHER', isTablet, isLandscape),
              _buildSettingsCard(
                context,
                [
                  _buildPrivacyPolicyItem(context, isTablet),
                  _buildDivider(),
                  _buildTermsItem(context, isTablet),
                ],
                isTablet,
              ),
              
              // Espacement final
              SizedBox(height: isTablet ? 40 : 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isTablet, bool isLandscape) {
    return Padding(
      padding: EdgeInsets.only(
        left: isTablet ? 24 : 16,
        top: isLandscape ? 12 : 16,
        bottom: 8,
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey,
          fontSize: isTablet ? 14 : 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context, List<Widget> children, bool isTablet) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isTablet ? 16 : 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: isTablet ? BorderRadius.circular(12) : BorderRadius.zero,
        boxShadow: isTablet ? [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
      child: Column(children: children),
    );
  }

  Widget _buildLanguageItem(BuildContext context, bool isTablet) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: isTablet ? 24 : 16,
        vertical: isTablet ? 4 : 0,
      ),
      title: Text(
        'Language',
        style: TextStyle(
          fontSize: isTablet ? 18 : 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'English',
            style: TextStyle(
              color: Colors.grey,
              fontSize: isTablet ? 16 : 14,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.chevron_right, 
            color: Colors.grey,
            size: isTablet ? 24 : 20,
          ),
        ],
      ),
      onTap: () {
        _showLanguageDialog(context);
      },
    );
  }

  Widget _buildPrivacyPolicyItem(BuildContext context, bool isTablet) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: isTablet ? 24 : 16,
        vertical: isTablet ? 4 : 0,
      ),
      title: Text(
        'Privacy Policy',
        style: TextStyle(
          fontSize: isTablet ? 18 : 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right, 
        color: Colors.grey,
        size: isTablet ? 24 : 20,
      ),
      onTap: () {
        _showInfoDialog(context, 'Privacy Policy', 'Privacy policy content would be displayed here.');
      },
    );
  }

  Widget _buildTermsItem(BuildContext context, bool isTablet) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: isTablet ? 24 : 16,
        vertical: isTablet ? 4 : 0,
      ),
      title: Text(
        'Terms and Conditions',
        style: TextStyle(
          fontSize: isTablet ? 18 : 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right, 
        color: Colors.grey,
        size: isTablet ? 24 : 20,
      ),
      onTap: () {
        _showInfoDialog(context, 'Terms and Conditions', 'Terms and conditions content would be displayed here.');
      },
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1, 
      indent: 16, 
      endIndent: 0,
      color: Colors.grey,
    );
  }

  // Dialogues interactifs
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('English'),
                leading: const Icon(Icons.check, color: Colors.blue),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                title: const Text('Français'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                title: const Text('Español'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showInfoDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Méthodes utilitaires pour le responsive
  double _getHorizontalPadding(Size screenSize, bool isTablet) {
    if (isTablet) return screenSize.width * 0.1;
    return 0;
  }

  double _getContentWidth(Size screenSize, bool isTablet) {
    if (isTablet) return 600;
    return screenSize.width;
  }
}