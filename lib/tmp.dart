import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    
    return MaterialApp(
      title: 'Profil',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const ProfilePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 16 : 8),
              height: isTablet ? 60 : 52,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios, 
                      color: Colors.black, 
                      size: isTablet ? 24 : 20
                    ),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Profile',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: isTablet ? 22 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: isTablet ? 56 : 48),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isTablet ? 600 : double.infinity,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: isTablet ? 30 : 20,
                          horizontal: 16,
                        ),
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  width: isTablet ? 120 : 100,
                                  height: isTablet ? 120 : 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFFFF9800),
                                      width: isTablet ? 3 : 2,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: Image.asset(
                                      'assets/photo_profil.jpg',
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey[300],
                                          child: Icon(
                                            Icons.person,
                                            size: isTablet ? 60 : 50,
                                            color: Colors.grey[600],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(isTablet ? 6 : 4),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFF9800),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: isTablet ? 20 : 16,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: isTablet ? 16 : 12),
                            Text(
                              'Mohammed',
                              style: TextStyle(
                                fontSize: isTablet ? 24 : 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: isTablet ? 32 : 16),
                        child: Column(
                          children: [
                            _buildProfileOption(
                              context: context,
                              icon: Icons.person,
                              iconColor: const Color(0xFFFF9800),
                              title: 'Edit Profile',
                              onTap: () {},
                              isTablet: isTablet,
                            ),
                            const Divider(height: 1),
                            _buildProfileOption(
                              context: context,
                              icon: Icons.bookmark,
                              iconColor: const Color(0xFFFF9800),
                              title: 'Saved',
                              onTap: () {},
                              isTablet: isTablet,
                            ),
                            const Divider(height: 1),
                            _buildProfileOption(
                              context: context,
                              icon: Icons.history,
                              iconColor: const Color(0xFFFF9800),
                              title: 'History',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HistoryPage(),
                                  ),
                                );
                              },
                              isTablet: isTablet,
                            ),
                            const Divider(height: 1),
                            _buildProfileOption(
                              context: context,
                              icon: Icons.settings,
                              iconColor: const Color(0xFFFF9800),
                              title: 'Settings',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SettingsPage(),
                                  ),
                                );
                              },
                              isTablet: isTablet,
                            ),
                            const Divider(height: 1),
                          ],
                        ),
                      ),
                      
                      Padding(
                        padding: EdgeInsets.all(isTablet ? 32 : 24),
                        child: Container(
                          width: double.infinity,
                          constraints: BoxConstraints(
                            maxWidth: isTablet ? 400 : double.infinity,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFFF9800),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextButton.icon(
                            onPressed: () {
                              _showSignOutDialog(context);
                            },
                            icon: Icon(
                              Icons.logout,
                              color: const Color(0xFFFF9800),
                              size: isTablet ? 22 : 18,
                            ),
                            label: Text(
                              'Sign Out',
                              style: TextStyle(
                                color: const Color(0xFFFF9800),
                                fontWeight: FontWeight.w500,
                                fontSize: isTablet ? 18 : 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            Container(
              height: isTablet ? 70 : 60,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    icon: Icons.home_outlined, 
                    label: 'Home', 
                    isSelected: false,
                    isTablet: isTablet,
                  ),
                  _buildNavItem(
                    icon: Icons.view_list_outlined, 
                    label: 'Journal', 
                    isSelected: false,
                    isTablet: isTablet,
                  ),
                  _buildNavItem(
                    icon: Icons.calendar_month_outlined, 
                    label: 'Calendar', 
                    isSelected: false,
                    isTablet: isTablet,
                  ),
                  _buildNavItem(
                    icon: Icons.chat_bubble_outline, 
                    label: 'Rendome', 
                    isSelected: false,
                    isTablet: isTablet,
                  ),
                  _buildNavItem(
                    icon: Icons.person_outline, 
                    label: 'Profile', 
                    isSelected: true,
                    isTablet: isTablet,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Sign Out',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: const Text(
            'Are you sure you want to sign out?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performSignOut(context);
              },
              child: const Text(
                'Sign Out',
                style: TextStyle(
                  color: Color(0xFFFF9800),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _performSignOut(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Successfully signed out'),
        backgroundColor: Color(0xFFFF9800),
        duration: Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      debugPrint('User signed out successfully');
    });
  }

  Widget _buildProfileOption({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
    required bool isTablet,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        vertical: isTablet ? 8 : 0,
        horizontal: 0,
      ),
      leading: Container(
        padding: EdgeInsets.all(isTablet ? 12 : 8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: isTablet ? 28 : 24,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: isTablet ? 18 : 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey,
        size: isTablet ? 28 : 24,
      ),
      onTap: onTap,
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required bool isTablet,
  }) {
    final color = isSelected ? const Color(0xFFFF9800) : Colors.grey;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: color,
          size: isTablet ? 28 : 24,
        ),
        SizedBox(height: isTablet ? 6 : 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: isTablet ? 14 : 12,
          ),
        ),
      ],
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
            _buildAppBar(context, isTablet),
            Expanded(
              child: _buildMainContent(context, screenSize, isTablet, isLandscape),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isTablet) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: isTablet ? 60 : 52,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios, 
              color: Colors.black, 
              size: isTablet ? 24 : 20,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Text(
            'Settings',
            style: TextStyle(
              color: Colors.black,
              fontSize: isTablet ? 20 : 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: isTablet ? 56 : 48),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, Size screenSize, bool isTablet, bool isLandscape) {
    final double contentWidth = _getContentWidth(screenSize, isTablet);

    return SizedBox(
      width: double.infinity,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: contentWidth),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildSectionHeader('PROFILE', isTablet, isLandscape),
              _buildSettingsCard(
                context,
                [
                  _buildLanguageItem(context, isTablet),
                ],
                isTablet,
              ),
              
              SizedBox(height: isLandscape ? 16 : 24),
              
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

  double _getContentWidth(Size screenSize, bool isTablet) {
    if (isTablet) return 600;
    return screenSize.width;
  }
}

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 16 : 8),
              height: isTablet ? 60 : 52,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios, 
                      color: Colors.black, 
                      size: isTablet ? 24 : 20
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'History',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: isTablet ? 22 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: isTablet ? 56 : 48),
                ],
              ),
            ),
            
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.event_note,
                      size: isTablet ? 100 : 80,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: isTablet ? 24 : 16),
                    Text(
                      'No history yet',
                      style: TextStyle(
                        fontSize: isTablet ? 24 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isTablet ? 12 : 8),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 40 : 24,
                      ),
                      child: Text(
                        'Hit the orange button down\nbelow to Create an order',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isTablet ? 16 : 14,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            Container(
              height: isTablet ? 70 : 60,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    icon: Icons.home_outlined, 
                    label: 'Home', 
                    isSelected: false,
                    isTablet: isTablet,
                  ),
                  _buildNavItem(
                    icon: Icons.view_list_outlined, 
                    label: 'Journal', 
                    isSelected: false,
                    isTablet: isTablet,
                  ),
                  _buildNavItem(
                    icon: Icons.calendar_month_outlined, 
                    label: 'Calendar', 
                    isSelected: false,
                    isTablet: isTablet,
                  ),
                  _buildNavItem(
                    icon: Icons.chat_bubble_outline, 
                    label: 'Rendome', 
                    isSelected: false,
                    isTablet: isTablet,
                  ),
                  _buildNavItem(
                    icon: Icons.person_outline, 
                    label: 'Profile', 
                    isSelected: false,
                    isTablet: isTablet,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required bool isTablet,
  }) {
    final color = isSelected ? const Color(0xFFFF9800) : Colors.grey;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: color,
          size: isTablet ? 28 : 24,
        ),
        SizedBox(height: isTablet ? 6 : 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: isTablet ? 14 : 12,
          ),
        ),
      ],
    );
  }
}