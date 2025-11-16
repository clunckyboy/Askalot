import 'package:askalot/screens/interests_screen.dart';
import 'package:askalot/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  int _selectedIndex = 0;

  Widget _buildInfoLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        color: Colors.grey[400],
        fontSize: 16,
      ),
    );
  }

  Widget _buildInfoValue(String value) {
    return Text(
      value,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildInterestChip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: const Color(0xFF7A6BFF),
    );
  }

  Widget _buildActionButton({
    required String text,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF3D425B),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(icon, color: color,),
          ],
        ),
      ),
    );
  }

  void _onCenterButtonPressed() {
    // Logika saat tombol '+' ditekan
    print('Tombol Tengah Ditekan!');
    // Misalnya, tampilkan dialog, bottom sheet, atau navigasi ke layar baru
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 200,
        child: const Center(
          child: Text('Buka Halaman Baru'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: (){},
        ),
        title: Text(
          'Account',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profil atas
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/askalot.png'),
                    ),
                    const SizedBox(height: 16,),
                    const Text(
                      'BlueElectric05',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4,),
                    Text(
                      'negus69@gmail.com',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40,),

              // Profil bawah
              const Center(
                child: Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20,),

              _buildInfoValue('Bio'),

              const SizedBox(height: 8),

              _buildInfoValue('Nerdy Hedgehog who draws for a living'),

              const SizedBox(height: 24),

              _buildInfoLabel('Interest'),

              const SizedBox(height: 12,),

              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  _buildInterestChip('Computer Science'),
                  _buildInterestChip('Food'),
                  _buildInterestChip('Art'),
                  _buildInterestChip('Garden'),
                ],
              ),

              const SizedBox(height: 40,),

              // Bagian akun
              const Center(
                child: Text(
                  'Account',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20,),

              _buildInfoLabel('Email'),

              const SizedBox(height: 8,),

              _buildInfoValue('negus69@gmail.com'),

              const SizedBox(height: 24,),

              _buildInfoLabel('Username'),

              const SizedBox(height: 8,),

              _buildInfoValue('BlueElectric05'),

              const SizedBox(height: 24,),

              _buildInfoLabel('Password'),

              const SizedBox(height: 28,),

              _buildInfoValue('**************'),

              const SizedBox(height: 40,),

              // Bagian tombol
              _buildActionButton(
                text: 'Edit',
                icon: Icons.edit,
                color: Colors.white,
                onPressed: (){},
              ),

              const SizedBox(height: 12,),

              _buildActionButton(
                text: 'Logout',
                icon: Icons.logout,
                color: Colors.red[400]!,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavbar(
          selectedIndex: _selectedIndex,
          onTabSelected: (index) {
            setState(() => _selectedIndex = index);
          },
          onCenterButtonPressed: _onCenterButtonPressed,
      ),
    );
  }
}