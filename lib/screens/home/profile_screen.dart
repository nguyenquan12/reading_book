import 'package:book_sale_apps/data/api/user_api.dart';
import 'package:book_sale_apps/data/models/user_model.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<UserModel> user;

  @override
  void initState() {
    super.initState();
    user = UserApi.getuser(); // Khởi tạo giá trị ban đầu
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hồ Sơ Cá Nhân',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        // Background
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue,
              Colors.purple,
            ],
          ),
        ),
        child: FutureBuilder(
          future: user,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Lỗi: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text("Không có dữ liệu người dùng."));
            } else {
              var data = snapshot.data!;
              return SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar
                    ClipOval(
                      child: Image.network(
                        width: MediaQuery.of(context).size.width * 1 / 4,
                        height: MediaQuery.of(context).size.width * 1 / 4,
                        data.image ?? "",
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 16),
                    // Name
                    Text(
                      data.firstName ?? "ABC",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    // Email
                    Text(
                      data.email ?? " ",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 24),
                    // Functional Options Section
                    Card(
                      elevation: 20.0,
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.edit, color: Colors.blueAccent),
                            title: Text('Chỉnh sửa thông tin'),
                            trailing: Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              // Navigate to Edit Profile Screen
                            },
                          ),
                          Divider(),
                          ListTile(
                            leading: Icon(Icons.shopping_bag,
                                color: Colors.blueAccent),
                            title: Text('Lịch sử đọc sách'),
                            trailing: Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              // Navigate to Order History Screen
                            },
                          ),
                          Divider(),
                          ListTile(
                            leading: Icon(Icons.lock, color: Colors.blueAccent),
                            title: Text('Đổi mật khẩu'),
                            trailing: Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              // Navigate to Change Password Screen
                            },
                          ),
                          Divider(),
                          ListTile(
                            leading:
                                Icon(Icons.logout, color: Colors.redAccent),
                            title: Text('Đăng xuất'),
                            trailing: Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              // Handle logout functionality
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}