import 'package:askalot/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';

class EditAccountScreen extends StatefulWidget {
  const EditAccountScreen({super.key});

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {

  _onCenterButtonPressed(){}
  int _selectedIndex = 1;

  Widget _buildInterestChip(String label){
    return Chip(
      label: Text(label),
      backgroundColor: Color(0xFF3D425B),
      labelStyle: TextStyle(color: Colors.white),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    );
  }

  Widget _buildEditableTextField({
    required String label,
    required String initialValue,
    bool obscureText = false,
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

        SizedBox(height: 8,),

        TextFormField(
          initialValue: initialValue,
          obscureText: obscureText,
          style: TextStyle(fontSize: 16),
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.edit, size: 20,),
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
          onPressed: (){},
        ),
        title: Text(
          'Edit Account',
          style: TextStyle(fontWeight: FontWeight.bold,),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: (){},
          ),
        ],
      ),

      body: SingleChildScrollView(
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
                      backgroundImage: AssetImage('assets/images/askalot.png'),
                    ),
                    Positioned(
                      width: 50,
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF3D425B),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xFF2C2C2E),
                            width: 2,
                          ),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(4),
                          child: IconButton(
                            icon: Icon(Icons.edit),
                            color: Colors.white,
                            onPressed: (){},
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),

              SizedBox(height: 16,),

              Center(
                child: Text(
                  'BlueElectric',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(height: 4,),

              Center(
                child: Text(
                  'negus69@email.com',
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
                initialValue: 'Nerdy hedgehog who draws for a living',
              ),

              SizedBox(height: 24,),

              // Interests
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Interests',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 12,),
                  Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: [
                            _buildInterestChip('Computer Science'),
                            _buildInterestChip('Food'),
                            _buildInterestChip('Art'),
                          ],
                        ),
                      ),
                      SizedBox(width: 8,),
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.grey,),
                        onPressed: (){},
                      )
                    ],
                  ),
                ],
              ),

              SizedBox(height: 40,),

              // BAGIAN ACCOUNT
              _buildSectionHeader('Account'),

              SizedBox(height: 20,),

              _buildEditableTextField(
                label: 'Email',
                initialValue: 'negus69@email.com',
              ),

              SizedBox(height: 24),

              _buildEditableTextField(
                label: 'Username',
                initialValue: 'BlueElectric05',
              ),

              SizedBox(height: 24,),

              _buildEditableTextField(
                label: 'Password',
                initialValue: '*********',
                obscureText: true
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