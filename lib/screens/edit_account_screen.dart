import 'package:askalot/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditAccountScreen extends StatefulWidget {
  const EditAccountScreen({super.key});

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {

  bool _isLoading = true;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  String _email = '';
  String _avatarPath = '';
  List<String> _interests = [];

  @override
  void initState(){
    super.initState();
    _fetchUserData();
  }

  @override
  void dispose(){
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      if(user == null){
        if(mounted) context.go('/signin');
        return;
      }

      final data = await supabase
          .from('users')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      if(data != null && mounted){
        setState(() {
          _usernameController.text = data['username'] ?? '';
          _bioController.text = data['bio'] ?? '';

          _email = data['email'] ?? user.email ?? '';
          _avatarPath = data['profile_pic'] ?? '';

          if(data['fav_topics'] != null){
            _interests = List<String>.from(data['fav_topics']);
          }

          _isLoading = false;
        });
      }
    } catch(e) {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"),));
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveChanges() async {
    setState(() => _isLoading = true);
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      if(user == null) return;

      await supabase.from('users').update({
        'username': _usernameController.text.trim(),
        'bio': _bioController.text.trim(),
      }).eq('user_id', user.id);

      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profil berhasil diperbarui!")),
        );
        context.pop(true);
      }
    } catch (e) {
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal menyimpan: $e"))
        );
      }
    } finally {
      if(mounted) setState(() => _isLoading = false);
    }
  }

  ImageProvider _getAvatarProvider() {
    if (_avatarPath.isEmpty) return const AssetImage('assets/images/askalot.png');
    if (_avatarPath.startsWith('http')) return NetworkImage(_avatarPath);
    try {
      final url = Supabase.instance.client.storage.from('profile_pic').getPublicUrl(_avatarPath);
      return NetworkImage(url);
    } catch (e) {
      return const AssetImage('assets/images/askalot.png');
    }
  }


  _onCenterButtonPressed(){}
  int _selectedIndex = 1;

  Widget _buildInterestChip(String label){
    return Chip(
      label: Text(label),
      backgroundColor: Color(0xFF3D425B),
      labelStyle: TextStyle(color: Colors.white),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }

  Widget _buildEditableTextField({
    required String label,
    required TextEditingController controller,
    bool obscureText = false,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),

        const SizedBox(height: 8,),

        TextFormField(
          controller: controller,
          obscureText: obscureText,
          readOnly: readOnly,
          style: TextStyle(fontSize: 16, color: readOnly ? Colors.grey : Colors.white),
          decoration: InputDecoration(
            suffixIcon: readOnly ? null : const Icon(Icons.edit, size: 20, color: Colors.grey,),
            filled: true,
            fillColor: readOnly ? Colors.black12 : Colors.transparent,
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF7A6BFF))),
          ),
        )
      ],
    );
  }

  Widget _buildReadOnlyField({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          readOnly: true,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.black12,
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          ),
        )
      ],
    );
  }

  Widget _buildSectionHeader(String title){
    return Center(
      child: Text(
        title,
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Color(0xFF2B2D35),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: (){
            context.pop();
          },
        ),
        title: Text(
          'Edit Account',
          style: TextStyle(fontWeight: FontWeight.bold,),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: _isLoading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Color(0xFF7A6BFF), strokeWidth: 2,))
                : const Icon(Icons.check, color: Color(0xFF7A6BFF),),
            onPressed: _isLoading ? null : _saveChanges,
          ),
        ],
      ),

      body: _isLoading
        ? const Center(child: CircularProgressIndicator(),)
        : SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Foto Profil
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 75,
                        backgroundImage: _getAvatarProvider(),
                    ),
                    Positioned(
                      width: 50, bottom: 0, right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF3D425B),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xFF2C2C2E),
                            width: 2,
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.edit, size: 20, color: Colors.white),
                          onPressed: () {},
                        ),
                      ),
                    )
                  ],
                ),
              ),

              SizedBox(height: 16,),

              Center(
                child: Text(
                  _usernameController.text,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(height: 4,),

              Center(
                child: Text(
                  _email,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[400],
                  ),
                ),
              ),

              SizedBox(height: 40),

              // BAGIAN PROFILE
              _buildSectionHeader('Profile'),

              SizedBox(height: 20,),

              // Bio
              _buildEditableTextField(
                label: 'BIO',
                controller: _bioController,
              ),

              SizedBox(height: 24,),

              // Interests
              const Text('Interest', style: TextStyle(color: Colors.white,fontSize: 16),),

              SizedBox(height: 12,),

              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 8.0, runSpacing: 8.0,
                      children: _interests.map((topic) => _buildInterestChip(topic)).toList(),
                    ),
                  ),

                  SizedBox(width: 8,),

                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.grey),
                    onPressed: (){
                      // Navigasi ke halaman edit interest
                    },
                  )
                ],
              ),

              SizedBox(height: 40,),

              _buildSectionHeader('Account'),

              SizedBox(height: 20,),

              _buildReadOnlyField(
                label: 'Email',
                value: _email,
              ),

              SizedBox(height: 24,),

              _buildReadOnlyField(
                label: 'Password',
                value: '**********',
              ),

              SizedBox(height: 50,),
            ],
          ),
        ),
      ),
    );
  }
}