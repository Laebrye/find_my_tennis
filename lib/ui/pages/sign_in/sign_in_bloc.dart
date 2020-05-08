import 'dart:async';

import 'package:find_my_tennis/services/auth.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import 'sign_in_model.dart';

class SignInBloc {
  SignInBloc({@required this.auth});
  final AuthBase auth;
  final _modelSubject = BehaviorSubject<SignInModel>.seeded(SignInModel());

  Stream<SignInModel> get modelStream => _modelSubject.stream;

  SignInModel get _model => _modelSubject.value;

  void dispose() {
    _modelSubject.close();
  }

  void toggleFormType() {
    final formType = _model.formType == SignInFormType.signIn
        ? SignInFormType.register
        : SignInFormType.signIn;
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
    SignInFormType formType,
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
      if (_model.formType == SignInFormType.signIn) {
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
