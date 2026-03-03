import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Email"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Please check your email and verify your account.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Tombol cek apakah sudah verifikasi
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.currentUser?.reload();

                final user = FirebaseAuth.instance.currentUser;

                if (user != null && user.emailVerified) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Email sudah diverifikasi!")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Email belum diverifikasi")),
                  );
                }
              },
              child: const Text("I have verified"),
            ),

            const SizedBox(height: 10),

            // Tombol kirim ulang email
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.currentUser
                    ?.sendEmailVerification();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Email verifikasi dikirim ulang")),
                );
              },
              child: const Text("Resend Email"),
            ),
          ],
        ),
      ),
    );
  }
}