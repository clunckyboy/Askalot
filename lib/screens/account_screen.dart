import 'package:askalot/screens/interests_screen.dart';
import 'package:askalot/widgets/bottom_navbar.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  bool _isLoading = true;
  String _username = '';
  String _email = '';
  String _bio = '';
  String _avatarPath = '';
  List<String> _interests = [];

  Future<void> _fetchUserProfile() async {

    await Future.delayed(Duration.zero);

    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      if (user == null) {
        // Jika tidak ada user login, kembalikan ke login screen
        if (mounted) context.go('/signin');
        return;
      }

      // Ambil data dari tabel 'users' berdasarkan ID user yang login
      final response = await supabase
          .from('users')
          .select()
          .eq('user_id', user.id)
          .single(); // .single() karena kita yakin hanya ada 1 data per ID

      if (mounted) {
        setState(() {
          _username = response['username'] ?? 'User';
          _email = response['email'] ?? user.email ?? '';
          _bio = response['bio'] ?? '';

          // Handling Avatar Path
          _avatarPath = response['profile_pic'] ?? '';

          if (response['fav_topics'] != null) {
            _interests = List<String>.from(response['fav_topics']);
          }

          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching profile: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat profil: $e')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  // 2. Fungsi Logout
  Future<void> _handleLogout() async {
    try {
      await Supabase.instance.client.auth.signOut();
      if (mounted) {
        context.go('/signin'); // Kembali ke halaman login menggunakan GoRouter
      }
    } catch (e) {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal logout: $e')),
        );
      }
    }
  }

  // 3. Helper Avatar: Mengubah Path Storage menjadi URL Publik
  String _getPublicUrl(String path) {
    try {
      // GANTI 'avatars' SESUAI NAMA BUCKET ANDA (misal: 'profile_pic' atau 'avatars')
      return Supabase.instance.client.storage.from('profile_pic').getPublicUrl(path);
    } catch (e) {
      return path;
    }
  }

  // 4. Helper Avatar Provider: Menentukan ImageProvider (Network vs Asset)
  ImageProvider _getAvatarProvider() {
    // A. Jika path kosong -> Pakai Asset Default
    if (_avatarPath.isEmpty) {
      return const AssetImage('assets/images/askalot.png');
    }

    // B. Jika path diawali http (misal login Google) -> Pakai Network
    if (_avatarPath.startsWith('http')) {
      return NetworkImage(_avatarPath);
    }

    // C. Jika path Storage Supabase (misal "folder/img.jpg") -> Generate URL lalu Network
    final publicUrl = _getPublicUrl(_avatarPath);
    return NetworkImage(publicUrl);
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Color(0xFF2C2C3E),
        title: Text(
          'Account',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profil atas
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _getAvatarProvider(), // Panggil fungsi dinamis
                      onBackgroundImageError: (_,__) {
                        // Fallback jika network error (opsional)
                      },
                    ),
                    const SizedBox(height: 16,),
                    Text(
                      _username, // Data Dinamis
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4,),
                    Text(
                      _email, // Data Dinamis
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
              _buildInfoValue(_bio), // Data Dinamis

              const SizedBox(height: 24),

              _buildInfoLabel('Interest'),
              const SizedBox(height: 12,),

              // Interests Dinamis
              _interests.isEmpty
                  ? Text("-", style: TextStyle(color: Colors.grey[400]))
                  : Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: _interests.map((topic) => _buildInterestChip(topic)).toList(),
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
              _buildInfoValue(_email), // Data Dinamis

              const SizedBox(height: 24,),

              _buildInfoLabel('Username'),
              const SizedBox(height: 8,),
              _buildInfoValue(_username), // Data Dinamis

              const SizedBox(height: 24,),

              _buildInfoLabel('Password'),
              const SizedBox(height: 28,),
              _buildInfoValue('**************'), // Password tidak ditampilkan demi keamanan

              const SizedBox(height: 40,),

              // Bagian tombol
              _buildActionButton(
                text: 'Edit',
                icon: Icons.edit,
                color: Colors.white,
                onPressed: (){
                  // Navigasi ke Edit Screen (perlu dibuat terpisah)
                },
              ),

              const SizedBox(height: 12,),

              _buildActionButton(
                text: 'Logout',
                icon: Icons.logout,
                color: Colors.red[400]!,
                onPressed: _handleLogout, // Panggil fungsi Logout
              ),
            ],
          ),
        ),
      ),
    );
  }
}