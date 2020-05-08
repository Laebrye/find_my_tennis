import 'dart:ui';

import 'package:find_my_tennis/ui/pages/sign_in/validators.dart';

enum SignInFormType { signIn, register }

class SignInModel with EmailAndPasswordValidators {
  SignInModel({
    this.email = '',
    this.password = '',
    this.formType = SignInFormType.signIn,
    this.isLoading = false,
    this.submitted = false,
  });
  final String email;
  final String password;
  final SignInFormType formType;
  final bool isLoading;
  final bool submitted;

  String get primaryButtonText {
    return formType == SignInFormType.signIn ? 'Sign in' : 'Create an account';
  }

  String get secondaryButtonText {
    return formType == SignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';
  }

  bool get canSubmit {
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        !isLoading;
  }

  String get passwordErrorText {
    bool showErrorText = submitted && !passwordValidator.isValid(password);
    return showErrorText ? invalidPasswordErrorText : null;
  }

  String get emailErrorText {
    bool showErrorText = submitted && !emailValidator.isValid(email);
    return showErrorText ? invalidEmailErrorText : null;
  }

  SignInModel copyWith({
    String email,
    String password,
    SignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    return SignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted,
    );
  }

  @override
  int get hashCode =>
      hashValues(email, password, formType, isLoading, submitted);

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final SignInModel otherModel = other as SignInModel;
    return email == otherModel.email &&
        password == otherModel.password &&
        formType == otherModel.formType &&
        isLoading == otherModel.isLoading &&
        submitted == otherModel.submitted;
  }

  @override
  String toString() =>
      'email: $email, password: $password, formType: $formType, isLoading: $isLoading, submitted: $submitted';
}
