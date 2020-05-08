import 'package:find_my_tennis/ui/pages/sign_in/sign_in_form.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  static const String id = 'sign_in_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in'),
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: SignInForm.create(context),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
