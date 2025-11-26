import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PostingScreen extends StatelessWidget {
  const PostingScreen({super.key});

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
              onPressed: (){},
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 5),
                backgroundColor: Color(0xFF7A6BFF),
              ),
              child: Text('Post'),
            ),
          ),
        ]
      ),
      body: Container(
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
                        backgroundImage: AssetImage('assets/images/askalot.png'),
                        onBackgroundImageError: null,
                      ),
                      // Image.asset(
                      //   'assets/images/askalot.png',
                      //   width: 50,
                      // ),
                      Padding(
                        padding: EdgeInsets.only(left: 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Blue Electric', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
                            Text('11 Sep', style: TextStyle(fontSize: 18),)
                          ],
                        )
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  // TextField untuk input pertanyaan
                  TextField(
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    maxLines: null, // Izinkan teks multi-baris
                    decoration: InputDecoration(
                      hintText: 'Ask something interesting!',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                      // Hilangkan garis bawah
                      border: InputBorder.none,
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(0xFF7A6BFF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Add tags',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ),

            ListTile(
              leading: Icon(Icons.gif_outlined, size: 40,),
              title: Text('GIF'),
            ),
            ListTile(
              leading: Icon(Icons.photo, size: 40,),
              title: Text('Photo'),
            ),
          ],
        ),
      ),
    );
  }
}