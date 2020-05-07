import 'dart:async';

import 'package:find_my_tennis/services/auth.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import 'email_sign_in_model.dart';


class EmailSignInBloc {
  EmailSignInBloc({@required this.auth});
  final AuthBase auth;
  final _modelSubject =
      BehaviorSubject<EmailSignInModel>.seeded(EmailSignInModel());

  Stream<EmailSignInModel> get modelStream => _modelSubject.stream;

  EmailSignInModel get _model => _modelSubject.value;

  void dispose() {
    _modelSubject.close();
  }

  void toggleFormType() {
    final formType = _model.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    updateWith(
      email: '',
      password: '',
      isLoading: false,
      submitted: false,
      formType: formType,
    );
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void updateWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    _modelSubject.add(
      _model.copyWith(
        email: email,
        password: password,
        formType: formType,
        isLoading: isLoading,
        submitted: submitted,
      ),
    );
  }

  Future<void> submit() async {
    updateWith(isLoading: true, submitted: true);
    try {
      if (_model.formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(
          _model.email,
          _model.password,
        );
      } else {
        await auth.createUserWithEmailAndPassword(
          _model.email,
          _model.password,
        );
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }
}
