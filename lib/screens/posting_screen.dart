import 'package:flutter/material.dart';

class PostingScreen extends StatelessWidget {
  const PostingScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2C2C3E),
        centerTitle: true,
        leading: IconButton(
          onPressed: (){},
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

          ],

        ),
      ),
    );
  }
}