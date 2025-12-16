import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class PostingScreen extends StatefulWidget {
  const PostingScreen({super.key});

  @override
  State<PostingScreen> createState() => _PostingScreenState();
}

class _PostingScreenState extends State<PostingScreen> {

  // Controller untuk teks
  final TextEditingController _contentController = TextEditingController();

  bool _isLoading = false;
  File? _selectedImage;

  String _username = 'Loading...';
  String _avatarPath = '';

  final ImagePicker _picker = ImagePicker();

  @override
  void initState(){
    super.initState();
    _fetchCurrentUser();
  }

  @override
  void dispose(){
    _contentController.dispose();
    super.dispose();
  }

  // Fetch data user (username & avatar)
  Future<void> _fetchCurrentUser() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if(user != null){
      try {
        final data =  await supabase
            .from('users')
            .select('username, profile_pic')
            .eq('user_id', user.id)
            .maybeSingle();

        if(data != null && mounted){
          setState(() {
            _username = data['username'] ?? 'User';
            _avatarPath = data['profile_pic'] ?? '';
          });
        }
      } catch (e) {
        print("Error fetching user: $e");
      }
    }
  }

  // Meload avatar
  ImageProvider _getAvatarProvider(){
    if(_avatarPath.isEmpty){
      return const AssetImage('assets/images/askalot.png');
    }
    if(_avatarPath.startsWith('http')){
      return NetworkImage(_avatarPath);
    }
    try {
      final url = Supabase.instance.client.storage.from('profile_pic').getPublicUrl(_avatarPath);
      return NetworkImage(url);
    } catch (e) {
      return const AssetImage('assets/images/askalot.png');
    }
  }

  // Fungsi mengambil image
  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  // Fungsi mengupload image ke server dan navigasi ke home screen
  Future<void> _handlePost() async {
    final content = _contentController.text.trim();

    if (content.isEmpty && _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tulis sesuatu atau upload gambar!")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      if (user == null) throw "User tidak terlogin";

      final DateTime now = DateTime.now();

      final String createdAtIso = now.toIso8601String();

      String? uploadedImageUrl;

      // A. Jika ada gambar, Upload dulu ke Storage
      if (_selectedImage != null) {
        final fileExt = _selectedImage!.path.split('.').last;
        final fileName = 'post_${now.millisecondsSinceEpoch}_${user.id}.$fileExt';

        // GANTI 'posts' DENGAN NAMA BUCKET POSTINGAN ANDA
        await supabase.storage.from('posts').upload(
          fileName,
          _selectedImage!,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
        );

        // Ambil Public URL
        uploadedImageUrl = supabase.storage.from('posts').getPublicUrl(fileName);
      }

      // Insert Data ke Table 'threads'
      await supabase.from('threads').insert({
        'user_id': user.id,
        'thread_content': content,
        'media_url': uploadedImageUrl, // null jika tidak ada gambar
        'media_type': _selectedImage != null ? 'image' : null,
        'created_at': createdAtIso,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Berhasil memposting!")),
        );

        // Arahkan ke Home (menggunakan go akan mereset stack home dan memicu fetch ulang)
        context.go('/home');
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal posting: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Tanggal real-time
  String _getCurrentDate() {
    final now = DateTime.now();
    const List<String> months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return "${now.day} ${months[now.month - 1]}";
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2C2C3E),
        centerTitle: true,
        leading: IconButton(
          onPressed: (){
            context.pop();
          },
          padding: EdgeInsets.zero,
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Ask'),
        toolbarHeight: 60,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handlePost,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 5),
                backgroundColor: Color(0xFF7A6BFF),
              ),
              child: _isLoading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('Post'),
            ),
          ),
        ]
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            // Halaman input
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Column(
                children: [
                  // Informasi
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: _getAvatarProvider(),
                        onBackgroundImageError: (_,__) {},
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _username,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              _getCurrentDate(),
                              style: TextStyle(fontSize: 18, color: Colors.grey[400]),
                            )
                          ],
                        )
                      )
                    ],
                  ),

                  const SizedBox(height: 20),

                  // TextField untuk input pertanyaan
                  TextField(
                    controller: _contentController,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    maxLines: null, // Izinkan teks multi-baris
                    decoration: InputDecoration(
                      hintText: 'Ask something interesting!',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                      border: InputBorder.none,
                    ),
                  ),

                  if (_selectedImage != null) ...[
                    const SizedBox(height: 15),
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _selectedImage!,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Tombol Hapus Gambar
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedImage = null),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close, color: Colors.white, size: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  SizedBox(height: 15),

                ],
              ),
            ),

            const Divider(color: Colors.grey, thickness: 0.2),

            ListTile(
              onTap: _pickImage,
              leading: Icon(Icons.photo, size: 35,),
              title: Text('Photo'),
            ),
          ],
        ),
      ),
    );
  }
}