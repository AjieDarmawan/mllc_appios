part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class ErrorOccured extends AuthState {
  const ErrorOccured();
  @override
  List<Object> get props => [];
  @override
  String toString() => 'Error Occured!';
}

class LoginFailure extends AuthState {
  final String status;

  const LoginFailure(this.status);
  @override
  List<Object> get props => [status];
  @override
  String toString() => 'Login Status: $status';
}

class AccountInactive extends AuthState {
  final String status;

  const AccountInactive(this.status);
  @override
  List<Object> get props => [status];
  @override
  String toString() => 'Login Status: $status';
}

class LoginSuccessful extends AuthState {
  final String status;
  final dynamic userData;

  const LoginSuccessful(this.status, this.userData);
  @override
  List<Object> get props => [status, userData];
  @override
  String toString() => 'Login Status: $status';
}

class ValidEmail extends AuthState {
  const ValidEmail();
  @override
  List<Object> get props => [];
  @override
  String toString() => 'Valid Email';
}

class InvalidEmail extends AuthState {
  final String status;

  const InvalidEmail(this.status);
  @override
  List<Object> get props => [status];
  @override
  String toString() => 'Invalid Email: $status';
}

class RegisterSuccessful extends AuthState {
  const RegisterSuccessful();
  @override
  List<Object> get props => [];
  @override
  String toString() => 'Register Successful';
}

class ForgotPasswordSuccessful extends AuthState {
  final String status;

  const ForgotPasswordSuccessful(this.status);
  @override
  List<Object> get props => [status];
  @override
  String toString() => 'Forgot Password Successful';
}

class UserNotFound extends AuthState {
  final String status;

  const UserNotFound(this.status);
  @override
  List<Object> get props => [status];
  @override
  String toString() => 'Forgot Password Error: $status';
}

class LogoutSuccessful extends AuthState {
  final String status;

  const LogoutSuccessful(this.status);
  @override
  List<Object> get props => [status];
  @override
  String toString() => status;
}

class GetUserDetailsSuccessful extends AuthState {
  final String status;
  final dynamic userData;

  const GetUserDetailsSuccessful(this.status, this.userData);
  @override
  List<Object> get props => [status, userData];
  @override
  String toString() => status;
}

class GetListDetailsSuccessful extends AuthState {
  final String status;
  final dynamic listData;

  const GetListDetailsSuccessful(this.status, this.listData);
  @override
  List<Object> get props => [status, listData];
  @override
  String toString() => status;
}

class UpdateSocialMediaSuccessful extends AuthState {
  final String status;

  const UpdateSocialMediaSuccessful(this.status);
  @override
  List<Object> get props => [status];
  @override
  String toString() => status;
}

class CreateSocialMediaSuccessful extends AuthState {
  final String status;

  const CreateSocialMediaSuccessful(this.status);
  @override
  List<Object> get props => [status];
  @override
  String toString() => status;
}

class UpdateDataSuccessful extends AuthState {
  final String status;

  const UpdateDataSuccessful(this.status);
  @override
  List<Object> get props => [status];
  @override
  String toString() => status;
}

class UpdatePersonalBasicInfoDataSuccessful extends AuthState {
  final String status;

  const UpdatePersonalBasicInfoDataSuccessful(this.status);
  @override
  List<Object> get props => [status];
  @override
  String toString() => status;
}

class CreateDataSuccessful extends AuthState {
  final String status;

  const CreateDataSuccessful(this.status);
  @override
  List<Object> get props => [status];
  @override
  String toString() => status;
}

class MatchedPassword extends AuthState {
  final String status;

  const MatchedPassword(this.status);
  @override
  List<Object> get props => [status];
  @override
  String toString() => status;
}

class PasswordNotMatch extends AuthState {
  final String status;

  const PasswordNotMatch(this.status);
  @override
  List<Object> get props => [status];
  @override
  String toString() => status;
}

class UpdateCompanySuccessful extends AuthState {
  final String status;

  const UpdateCompanySuccessful(this.status);
  @override
  List<Object> get props => [status];
  @override
  String toString() => status;
}
