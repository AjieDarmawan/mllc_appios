part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class UnloadAuthState extends AuthEvent {
  const UnloadAuthState();
  @override
  List<Object> get props => [];
}

class Login extends AuthEvent {
  final dynamic formData;

  const Login(this.formData);
  @override
  List<Object> get props => [formData];
}

class CheckEmail extends AuthEvent {
  final dynamic formData;

  const CheckEmail(this.formData);
  @override
  List<Object> get props => [formData];
}

class Register extends AuthEvent {
  final dynamic formData;

  const Register(this.formData);
  @override
  List<Object> get props => [formData];
}

class ForgotPassword extends AuthEvent {
  final dynamic formData;

  const ForgotPassword(this.formData);
  @override
  List<Object> get props => [formData];
}

class Logout extends AuthEvent {
  const Logout();
  @override
  List<Object> get props => [];
}

class GetUserDetails extends AuthEvent {
  final dynamic formData;

  const GetUserDetails(this.formData);
  @override
  List<Object> get props => [formData];
}

class GetWishlistDetail extends AuthEvent {
  final dynamic formData;

  const GetWishlistDetail(this.formData);
  @override
  List<Object> get props => [formData];
}

class CreateUpdateSocialMedia extends AuthEvent {
  final dynamic formData;

  const CreateUpdateSocialMedia(this.formData);
  @override
  List<Object> get props => [formData];
}

class CreateUpdateProfessionalCert extends AuthEvent {
  final dynamic formData;

  const CreateUpdateProfessionalCert(this.formData);
  @override
  List<Object> get props => [formData];
}

class CreateUpdateEducation extends AuthEvent {
  final dynamic formData;

  const CreateUpdateEducation(this.formData);
  @override
  List<Object> get props => [formData];
}

class CreateUpdateSocieties extends AuthEvent {
  final dynamic formData;

  const CreateUpdateSocieties(this.formData);
  @override
  List<Object> get props => [formData];
}

class CreateUpdateWorkExperienced extends AuthEvent {
  final dynamic formData;

  const CreateUpdateWorkExperienced(this.formData);
  @override
  List<Object> get props => [formData];
}

class UpdateUserDetail extends AuthEvent {
  final dynamic formData;

  const UpdateUserDetail(this.formData);
  @override
  List<Object> get props => [formData];
}

class DeleteUpdateSocialMedia extends AuthEvent {
  final dynamic formData;

  const DeleteUpdateSocialMedia(this.formData);
  @override
  List<Object> get props => [formData];
}

class CheckPassword extends AuthEvent {
  final dynamic formData;

  const CheckPassword(this.formData);
  @override
  List<Object> get props => [formData];
}

class UpdateCompanyDetail extends AuthEvent {
  final dynamic formData;

  const UpdateCompanyDetail(this.formData);
  @override
  List<Object> get props => [formData];
}
