import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../enums.dart';
import '../../model/shared/cache_helper.dart';
part 'themes_state.dart';

class ThemesCubit extends Cubit<ThemesState> {
  ThemesCubit() : super(ThemesInitial());
  static ThemesCubit get(context) => BlocProvider.of(context);

  bool isDark = false;

  void changeTheme(){
    isDark = !isDark;
    CacheHelper.putBOOL(key: SharedKeys.themeMood, value: isDark);
    emit(ChangeThemesState());
  }
 // sharedPref
  //Shp
  getTheme(){
    isDark = CacheHelper.getBOOL(key: SharedKeys.themeMood);
  }

}

