part of 'contact_cubit.dart';

@immutable
abstract class ContactState {}

class ContactInitial extends ContactState {}
class InsertContactSuccessState extends ContactState {}
class InsertContactErrorState extends ContactState {}


class UpdateContactSuccessState extends ContactState {}
class UpdateContactErrorState extends ContactState {}


class UpdateFavoriteSuccessState extends ContactState {}
class UpdateFavoriteErrorState extends ContactState {}

class LoadingGetContactsState extends ContactState {}
class GetContactSuccessState extends ContactState {}

class ErrorWhenGetDataState   extends ContactState {}
class LoadingGetFavoriteState extends ContactState {}
class GetFavoriteSuccessState extends ContactState {}
class ErrorWhenGetFavoriteDataState   extends ContactState {}

class DeleteSuccessState extends ContactState {}

class ChangeBottomState extends ContactState {}

class ChangeButtonNavbarState extends ContactState {}