import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Enter your email here',
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Enter your password here',
            ),
          ),
          TextButton(
            onPressed: () async {
  final email = _email.text;
  final password = _password.text;
  try {
    print('Attempting to register user with email: $email');
    await AuthService.firebase().createUser(
      email: email,
      password: password,
    );
    print('User created successfully, sending email verification...');
    await AuthService.firebase().sendEmailVerification();
    print('Email verification sent, navigating to verifyEmailRoute...');
    Navigator.of(context).pushNamed(verifyEmailRoute);
  } on WeakPasswordAuthException catch (e, stackTrace) {
    print('WeakPasswordAuthException: $e');
    print(stackTrace);
    await showErrorDialog(
      context,
      'Weak password',
    );
  } on EmailAlreadyInUseAuthException catch (e, stackTrace) {
    print('EmailAlreadyInUseAuthException: $e');
    print(stackTrace);
    await showErrorDialog(
      context,
      'Email is already in use',
    );
  } on InvalidEmailAuthException catch (e, stackTrace) {
    print('InvalidEmailAuthException: $e');
    print(stackTrace);
    await showErrorDialog(
      context,
      'This is an invalid email address',
    );
  } on GenericAuthException catch (e, stackTrace) {
    print('GenericAuthException caught: $e');
    print(stackTrace);
    await showErrorDialog(
      context,
      'Failed to register',
    );
  } catch (e, stackTrace) {
    // This will catch any other unexpected exceptions
    print('Unexpected exception caught: $e');
    print(stackTrace);
    await showErrorDialog(
      context,
      'An unexpected error occurred',
    );
  }
},

            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (route) => false,
              );
            },
            child: const Text('Already registered? Login here!'),
          )
        ],
      ),
    );
  }
}
