import 'package:flutter/material.dart';
import 'package:gift_manager/data/http/model/user_dto.dart';
import 'package:gift_manager/data/repository/user_repository.dart';
import 'package:gift_manager/data/storage/shared_preference_data.dart';
import 'package:gift_manager/di/service_locator.dart';
import 'package:gift_manager/presentation/login/view/login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            StreamBuilder<UserDto?>(
                stream: sl.get<UserRepository>().observeItem(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData && snapshot.data == null) {
                    return const Text('HomePage');
                  }
                  return Text(snapshot.data.toString());
                }),
            const SizedBox(height: 42),
            TextButton(
                onPressed: () async {
                  await sl.get<SharedPreferenceData>().setToken(null);
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                },
                child: const Text('Logout')),
          ],
        ),
      ),
    );
  }
}
