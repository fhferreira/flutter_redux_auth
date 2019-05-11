import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../actions/auth_actions.dart';
import '../models/app_state.dart';
import '../models/user.dart';
import '../services/repository.dart';

class AuthMiddleware {
  final Repository repository;

  const AuthMiddleware({this.repository = const Repository()});

  List<Middleware<AppState>> createAuthMiddleware() {
    return <Middleware<AppState>>[
      TypedMiddleware<AppState, AppStarted>(_appStarted),
      TypedMiddleware<AppState, UserLoginRequest>(_login),
      TypedMiddleware<AppState, UserLoginSuccess>(_loginSuccess),
      TypedMiddleware<AppState, UserLogout>(_logout),
      TypedMiddleware<AppState, UserMe>(_me),
    ];
  }

  void _appStarted(Store<AppState> store, AppStarted action, NextDispatcher next) async {
    print('_appStarted');
    next(action);

    if (await _hasToken()) {
      if (await _hasUser()) {
        print('_hasUser');

        final User user = await _getUser();

        print(user.first_name);
        print(user.last_name);
        print(user.picture);
        print(user.token);

        store.dispatch(UserMeLoaded(
            user: user
        ));
      } else {
        print('_hasToken');
        store.dispatch(UserLoaded(
            user: User(token: await _getToken())
        ));
      }
    }
  }


  void _login(Store<AppState> store, UserLoginRequest action, NextDispatcher next) async {
    next(action);

    try {
      final Map<String, dynamic> authData = await repository.login(action.email, action.password);
      print(authData);
      _persistToken(authData['access_token']);
      store.dispatch(UserLoginSuccess(
        token: authData['access_token']
      ));
    } catch (e) {
      store.dispatch(UserLoginFailure(error: e.toString()));
    }
  }

  void _loginSuccess(Store<AppState> store, UserLoginSuccess action, NextDispatcher next) async {
    next(action);

    store.dispatch(UserLoaded(
      user: User(token: action.token)
    ));

    store.dispatch(UserMe());
  }

  void _logout(Store<AppState> store, UserLogout action, NextDispatcher next) async {
    await _deleteToken();

    next(action);
  }

  void _me(Store<AppState> store, UserMe action, NextDispatcher next) async {
    String _token = await _getToken();

    try {
      final Map<String, dynamic> meData = await repository.me(_token);
      final User user = User.fromJsonData(meData, _token);
      _persistUser(user);
      store.dispatch(UserMeLoaded(user: user));
    } catch (e) {
      print(e);
      store.dispatch(UserError(error: e.toString()));
    }

    next(action);
  }

  /// HELPER FUNCTIONS
  Future<void> _persistUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('first_name', user.first_name);
    await prefs.setString('last_name', user.last_name);
    await prefs.setString('picture', user.picture);
    final token = prefs.getString('token');
    await prefs.setString('token', token);
  }

  Future<User> _getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final firstName = prefs.getString('first_name');
    final lastName = prefs.getString('last_name');
    final picture = prefs.getString('picture');
    final token = prefs.getString('token');
    return User(first_name:firstName, last_name:lastName, picture:picture, token:token);
  }
  
  Future<String> _getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> _deleteToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('first_name');
    await prefs.remove('last_name');
    await prefs.remove('picture');
    print('Token removed');
  }

  Future<void> _persistToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    print('Token: $token');
  }

  Future<bool> _hasToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';

    if (token != '') {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _hasUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String firstName = prefs.getString('first_name') ?? '';

    if (firstName != '') {
      return true;
    } else {
      return false;
    }
  }
}