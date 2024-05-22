part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}
class AuthRegisterByEmailState extends AuthState {}
class AuthLoginByEmailState extends AuthState {}
class RegisterByEmailAndPasswordSaveState extends AuthState {}
class AuthRegisterByGoogleState extends AuthState {}
class AuthLoadingState extends AuthState {}

class UploadPhotoState extends AuthState {}

class LoadUsersSuccessfully extends AuthState{}

class FailedToLoadUsers extends AuthState{}