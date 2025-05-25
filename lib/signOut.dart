import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ProfilePage(),
  ));
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Définir la barre d'état transparente
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    // Obtenir les dimensions de l'écran
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final isTablet = screenWidth > 600;
    final isLandscape = screenWidth > screenHeight;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          // Contenu principal
          Column(
            children: [
              // Barre d'état personnalisée - responsive
              Container(
                height: MediaQuery.of(context).padding.top + (isTablet ? 15 : 10),
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: isTablet ? 30 : 20),
                      child: Text(
                        '9:48',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: isTablet ? 16 : 14,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.signal_cellular_4_bar, size: isTablet ? 20 : 16),
                        SizedBox(width: isTablet ? 6 : 4),
                        Icon(Icons.wifi, size: isTablet ? 20 : 16),
                        SizedBox(width: isTablet ? 6 : 4),
                        Icon(Icons.battery_full, size: isTablet ? 20 : 16),
                        SizedBox(width: isTablet ? 30 : 20),
                      ],
                    ),
                  ],
                ),
              ),
              
              // App Bar - responsive
              Container(
                height: isTablet ? 70 : 56,
                padding: EdgeInsets.symmetric(horizontal: isTablet ? 8 : 4),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, 
                        color: Colors.black,
                        size: isTablet ? 28 : 24,
                      ),
                      onPressed: () {},
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Profile',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: isTablet ? 24 : 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: isTablet ? 56 : 48), // Pour compenser l'icône à gauche
                  ],
                ),
              ),
              
              // Profil - responsive layout
              Expanded(
                child: SingleChildScrollView(
                  child: isLandscape && !isTablet 
                    ? _buildLandscapeLayout(context, screenWidth, screenHeight)
                    : _buildPortraitLayout(context, screenWidth, isTablet),
                ),
              ),
            ],
          ),
          
          // Sign Out Dialog - responsive
          _buildSignOutDialog(context, screenWidth, isTablet),
        ],
      ),
    );
  }

  // Fonction pour afficher les options de changement de photo
  void _showImagePickerDialog(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Changer la photo de profil',
                style: TextStyle(
                  fontSize: isTablet ? 20 : 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20),
              
              // Option Caméra
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.camera_alt, color: Colors.blue, size: isTablet ? 24 : 20),
                ),
                title: Text(
                  'Prendre une photo',
                  style: TextStyle(fontSize: isTablet ? 18 : 16),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Code pour ouvrir la caméra
                  _takePhoto();
                },
              ),
              
              // Option Galerie
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.photo_library, color: Colors.green, size: isTablet ? 24 : 20),
                ),
                title: Text(
                  'Choisir dans la galerie',
                  style: TextStyle(fontSize: isTablet ? 18 : 16),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Code pour ouvrir la galerie
                  _pickFromGallery();
                },
              ),
              
              // Option Supprimer (si il y a déjà une photo)
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.delete, color: Colors.red, size: isTablet ? 24 : 20),
                ),
                title: Text(
                  'Supprimer la photo',
                  style: TextStyle(fontSize: isTablet ? 18 : 16),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Code pour supprimer la photo
                  _deletePhoto();
                },
              ),
              
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // Fonctions pour gérer les images
  void _takePhoto() {
    // Ici vous pouvez utiliser image_picker pour prendre une photo
    print("Ouvrir la caméra");
    // Exemple avec image_picker:
    // final ImagePicker picker = ImagePicker();
    // final XFile? image = await picker.pickImage(source: ImageSource.camera);
  }

  void _pickFromGallery() {
    // Ici vous pouvez utiliser image_picker pour choisir une image
    print("Ouvrir la galerie");
    // Exemple avec image_picker:
    // final ImagePicker picker = ImagePicker();
    // final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  }

  void _deletePhoto() {
    // Code pour supprimer la photo et remettre une image par défaut
    print("Supprimer la photo");
  }

  // Layout portrait (par défaut)
  Widget _buildPortraitLayout(BuildContext context, double screenWidth, bool isTablet) {
    final horizontalPadding = isTablet ? 40.0 : 20.0;
    final avatarRadius = isTablet ? 60.0 : 45.0;
    
    return Column(
      children: [
        // Photo de profil
        Center(
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: isTablet ? 20 : 10),
                width: avatarRadius * 2,
                height: avatarRadius * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.orange.shade200,
                    width: isTablet ? 3 : 2,
                  ),
                  image: DecorationImage(
                    // Changez le chemin de l'image ici
                    image: AssetImage('assets/photo_profil.jpg'), // ← Votre nouvelle image
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 5,
                right: 5,
                child: GestureDetector(
                  onTap: () {
                    // Action pour changer la photo
                    _showImagePickerDialog(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(isTablet ? 6 : 4),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      size: isTablet ? 22 : 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: isTablet ? 60 : 40),
        
        // Menu items
        _buildMenuItem(
          icon: Icons.edit,
          title: 'Edit Profile',
          iconColor: Colors.orange,
          isTablet: isTablet,
          horizontalPadding: horizontalPadding,
        ),
        _buildMenuItem(
          icon: Icons.bookmark_border,
          title: 'Saved',
          iconColor: Colors.orange,
          isTablet: isTablet,
          horizontalPadding: horizontalPadding,
        ),
        _buildMenuItem(
          icon: Icons.history,
          title: 'History',
          iconColor: Colors.orange,
          isTablet: isTablet,
          horizontalPadding: horizontalPadding,
        ),
        _buildMenuItem(
          icon: Icons.settings,
          title: 'Settings',
          iconColor: Colors.orange,
          isTablet: isTablet,
          horizontalPadding: horizontalPadding,
        ),
        
        SizedBox(height: isTablet ? 50 : 30),
        
        // Sign Out button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: SizedBox(
            width: isTablet ? 400 : double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: isTablet ? 16 : 12),
                side: BorderSide(color: Colors.orange),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Sign Out',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: isTablet ? 18 : 16,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 30), // Espace supplémentaire en bas
      ],
    );
  }

  // Layout paysage pour téléphones
  Widget _buildLandscapeLayout(BuildContext context, double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Colonne gauche - Photo de profil
          Expanded(
            flex: 1,
            child: Column(
              children: [
                SizedBox(height: 20),
                Stack(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.orange.shade200,
                          width: 2,
                        ),
                        image: DecorationImage(
                          // Changez le chemin de l'image ici pour le mode paysage
                          image: AssetImage('assets/new_profile_image.jpg'), // ← Votre nouvelle image
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: GestureDetector(
                        onTap: () {
                          _showImagePickerDialog(context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 2,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          SizedBox(width: 40),
          
          // Colonne droite - Menu items
          Expanded(
            flex: 2,
            child: Column(
              children: [
                SizedBox(height: 20),
                _buildMenuItem(
                  icon: Icons.edit,
                  title: 'Edit Profile',
                  iconColor: Colors.orange,
                  isTablet: false,
                  horizontalPadding: 0,
                ),
                _buildMenuItem(
                  icon: Icons.bookmark_border,
                  title: 'Saved',
                  iconColor: Colors.orange,
                  isTablet: false,
                  horizontalPadding: 0,
                ),
                _buildMenuItem(
                  icon: Icons.history,
                  title: 'History',
                  iconColor: Colors.orange,
                  isTablet: false,
                  horizontalPadding: 0,
                ),
                _buildMenuItem(
                  icon: Icons.settings,
                  title: 'Settings',
                  iconColor: Colors.orange,
                  isTablet: false,
                  horizontalPadding: 0,
                ),
                
                SizedBox(height: 20),
                
                // Sign Out button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      side: BorderSide(color: Colors.orange),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Sign Out',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Dialog responsive
  Widget _buildSignOutDialog(BuildContext context, double screenWidth, bool isTablet) {
    final dialogWidth = isTablet ? 400.0 : (screenWidth * 0.85).clamp(280.0, 320.0);
    
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: Container(
        color: Colors.black.withOpacity(0.2),
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Container(
            width: dialogWidth,
            constraints: BoxConstraints(
              maxWidth: isTablet ? 450 : 350,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: isTablet ? 30 : 20, 
                right: isTablet ? 30 : 20, 
                top: isTablet ? 30 : 20, 
                bottom: isTablet ? 24 : 16
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header avec "Sign Out" centré
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {},
                          child: Icon(Icons.close, size: isTablet ? 26 : 22),
                        ),
                      ),
                      Center(
                        child: Text(
                          'Sign Out',
                          style: TextStyle(
                            fontSize: isTablet ? 22 : 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isTablet ? 24 : 16),
                  Text(
                    'Do you want to log out?',
                    style: TextStyle(
                      fontSize: isTablet ? 18 : 16,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: isTablet ? 30 : 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: isTablet ? 16 : 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: Colors.grey[300]!),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontSize: isTablet ? 16 : 14,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: isTablet ? 15 : 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: isTablet ? 16 : 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Log Out',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: isTablet ? 16 : 14,
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
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon, 
    required String title, 
    required Color iconColor, 
    required bool isTablet,
    required double horizontalPadding,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding, 
        vertical: isTablet ? 16 : 12
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isTablet ? 12 : 8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: isTablet ? 26 : 22,
            ),
          ),
          SizedBox(width: isTablet ? 20 : 15),
          Text(
            title,
            style: TextStyle(
              fontSize: isTablet ? 18 : 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Spacer(),
          Icon(
            Icons.chevron_right,
            color: Colors.grey,
            size: isTablet ? 26 : 24,
          ),
        ],
      ),
    );
  }
}

// Méthode séparée pour afficher le dialogue - responsive
void showSignOutDialog(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  final isTablet = screenWidth > 600;
  final dialogWidth = isTablet ? 400.0 : (screenWidth * 0.85).clamp(280.0, 320.0);
  
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.2),
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: isTablet ? 50 : 30),
        child: Container(
          width: dialogWidth,
          constraints: BoxConstraints(
            maxWidth: isTablet ? 450 : 350,
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: isTablet ? 30 : 20, 
              right: isTablet ? 30 : 20, 
              top: isTablet ? 30 : 20, 
              bottom: isTablet ? 24 : 16
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header avec "Sign Out" centré
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.close, size: isTablet ? 26 : 22),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Sign Out',
                        style: TextStyle(
                          fontSize: isTablet ? 22 : 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isTablet ? 24 : 16),
                Text(
                  'Do you want to log out?',
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isTablet ? 30 : 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(vertical: isTablet ? 16 : 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            fontSize: isTablet ? 16 : 14,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: isTablet ? 15 : 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Code pour se déconnecter
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(vertical: isTablet ? 16 : 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'Log Out',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: isTablet ? 16 : 14,
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
    },
  );
}